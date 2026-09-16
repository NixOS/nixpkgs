# Foreign package backend: turn AUR / pacman / dnf (rpm) / deb package
# archives into a Nix store overlay.
#
#   pkgs.foreignPackages {
#     url  = "https://.../foo_1.0_amd64.deb";   # or .rpm / .pkg.tar.zst
#     hash = "sha256-...";
#     # format is detected from the URL suffix; one of:
#     #   "deb", "rpm", "pkgtar" (pacman packages and built AUR packages)
#   }
#
# AUR packages: pass the URL of a *built* AUR package (pkg.tar.zst, as
# produced by makepkg or an AUR package CI). AUR snapshots (PKGBUILD +
# sources) require an Arch Linux build environment with network access and
# are not buildable in an offline Nix derivation.
#
# The derivation:
#   1. downloads the package (fetchurl),
#   2. extracts it into its own store output, preserving the archive layout
#      (usr/, etc/, lib/, bin/, ... at the output root: a filesystem overlay),
#   3. runs the package's post-install script (deb postinst, rpm %post,
#      Arch .INSTALL) plus an optional `postInstall` command block inside a
#      bubblewrap sandbox with the overlay as the chroot root,
#   4. makes the output read-only.
#
# The output is a plain directory tree; NixOS can merge it into the FHS
# compatibility rootfs via `system.foreignPackages` (see
# nixos/modules/system/foreign-packages.nix).
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  rpm,
  cpio,
  libarchive,
  bubblewrap,
  busybox,
  coreutils,
  findutils,
  gnused,
  gnugrep,
  gawk,
  glibc,
}:

let
  inherit (lib) optionalString;

  bb = "${busybox}/bin/busybox"; # static busybox: /bin/sh + applets in the chroot
  toolsBins =
    lib.concatMapStringsSep "\n" (p: ''ln -sfn ${p}/bin/* "$out/usr/bin/" 2>/dev/null || true'')
      [
        coreutils
        findutils
        gnused
        gnugrep
        gawk
      ];

  detectFmt =
    u:
    if (match ".*\\.deb$" u != null) then
      "deb"
    else if (match ".*\\.rpm$" u != null) then
      "rpm"
    else if (match ".*\\.pkg\\.tar\\..*" u != null) then
      "pkgtar"
    else
      throw "foreign-packages: cannot detect the package format from URL '${u}'; set `format`.";
in
{
  url ? null,
  src ? null, # when set, url/hash are ignored (used for offline tests)
  hash ? null,
  format ? null,
  name ? null,
  postInstall ? null, # extra command block run inside the chroot after the package post-install
  ...
}:

let
  pkgSrc = if src != null then src else fetchurl { inherit url hash; };
  fmt = if format != null then format else detectFmt (toString url);
  baseName =
    if name != null then
      name
    else if url != null then
      baseNameOf url
    else
      src.name or (baseNameOf (toString src));
in
stdenv.mkDerivation {
  pname = "foreign-${baseName}";
  version = "0";

  src = pkgSrc;
  packageFormat = fmt;

  nativeBuildInputs = [
    dpkg
    rpm
    cpio
    libarchive
    bubblewrap
    busybox
    coreutils
    findutils
    gnused
    gnugrep
    gawk
  ];

  buildCommand = ''
    set -euo pipefail

    mkdir -p "$out"
    tmp="$(mktemp -d)"

    case "$packageFormat" in
      deb)
        dpkg-deb -x "$src" "$out"
        # control archive holds the maintainer scripts (postinst)
        mkdir -p "$tmp/control"
        dpkg-deb -e "$src" "$tmp/control" >/dev/null 2>&1 || true
        ;;
      rpm)
        rpm2cpio "$src" | cpio -idm -D "$out"
        ;;
      pkgtar)
        bsdtar -xf "$src" -C "$out"
        ;;
      *)
        echo "foreign-packages: unsupported format '$fmt'" >&2
        exit 1
        ;;
    esac

    # ---- prepare the chroot -------------------------------------------------
    mkdir -p "$out/nix/store" "$out/proc" "$out/dev" "$out/tmp" \
      "$out/bin" "$out/usr/bin" "$out/sbin" "$out/usr/sbin"

    # static shell for shebang lines; removed again after the chroot
    rm -f "$out/bin/sh" "$out/usr/bin/sh" "$out/bin/busybox"
    ln -s "${bb}" "$out/bin/busybox"
    ln -s "${bb}" "$out/bin/sh"
    ln -s "${bb}" "$out/usr/bin/sh"

    # coreutils etc. on the chroot PATH (dynamic; loader resolves under
    # the bound /nix/store)
    ${toolsBins}

    # ldconfig stub: postinst/post scripts commonly invoke it
    for d in sbin usr/sbin; do
      if [ -e "$out/''$d/ldconfig" ]; then continue; fi
      printf '#!/bin/sh\nexit 0\n' > "$out/''$d/ldconfig"
      chmod +x "$out/''$d/ldconfig"
    done

    # assemble the post-install steps into a script inside the chroot
    cat > "$out/tmp/postinstall.sh" <<'POSTEOF'
    #!/bin/sh
    export PATH="/bin:/usr/bin:/sbin:/usr/sbin:$PATH"
    ${optionalString (
      fmt == "deb"
    ) "[ -e /tmp/postinst ] && sh /tmp/postinst configure 0 >/dev/null 2>&1 || true"}
    ${optionalString (
      fmt == "rpm"
    ) "[ -e /tmp/rpm-post.sh ] && sh /tmp/rpm-post.sh >/dev/null 2>&1 || true"}
    ${optionalString (fmt == "pkgtar")
      ''[ -e /.INSTALL ] && sh ./.INSTALL post_install "$(awk '/^pkgver =/{print $3; exit}' .PKGINFO)" >/dev/null 2>&1 || true''
    }
    ${optionalString (postInstall != null) postInstall}
    POSTEOF
    chmod +x "$out/tmp/postinstall.sh"

    ${optionalString (fmt == "deb") ''
      cp -f "$tmp/control/postinst" "$out/tmp/postinst" 2>/dev/null || true
    ''}
    ${optionalString (fmt == "rpm") ''
      rpm -qp --scripts "$src" 2>/dev/null > "$tmp/scripts" || true
      awk '/^%post([[:space:]]+[^u]|$)/{f=1;next} /^%/{f=0} f' "$tmp/scripts" > "$out/tmp/rpm-post.sh" || true
      [ -s "$out/tmp/rpm-post.sh" ] || rm -f "$out/tmp/rpm-post.sh"
    ''}

    # ---- run the post-install in a chroot over the overlay ------------------
    ${bubblewrap}/bin/bwrap \
      --unshare-pid --unshare-ipc --unshare-uts --unshare-net \
      --die-with-parent \
      --bind "$out" / \
      --dev /dev \
      --proc /proc \
      --ro-bind /nix/store /nix/store \
      --chdir / \
      -- /bin/sh /tmp/postinstall.sh \
      || echo "foreign-packages: post-install exited with an error; continuing"

    # ---- clean up transient files and make the overlay read-only ------------
    rm -f "$out/bin/sh" "$out/usr/bin/sh" "$out/bin/busybox"
    rm -f "$out/tmp/postinstall.sh" "$out/tmp/postinst" "$out/tmp/rpm-post.sh" 2>/dev/null || true
    # remove the chroot tool symlinks we injected (anything pointing into
    # the Nix store under bin*/ was not part of the package)
    for d in bin usr/bin sbin usr/sbin; do
      for l in "$out/''$d"/*; do
        [ -L "$l" ] || continue
        case "$(readlink "$l")" in
          /nix/store/*) rm -f "$l" ;;
        esac
      done
    done
    # only remove ldconfig stubs we created (content match)
    for d in sbin usr/sbin; do
      f="$out/''$d/ldconfig"
      if [ -f "$f" ] && grep -q "^exit 0$" "$f"; then rm -f "$f"; fi
    done
    rmdir "$out/proc" "$out/dev" "$out/tmp" "$out/nix/store" "$out/nix" 2>/dev/null || true

    chmod -R a-w "$out"

    echo "foreign-package '$out' ($packageFormat) built and made read-only"
  '';
}
