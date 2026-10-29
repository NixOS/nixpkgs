{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  makeBinaryWrapper,
  pkg-config,
  asciidoc,
  libxslt,
  docbook_xsl,
  bash,
  kmod,
  binutils,
  bzip2,
  coreutils,
  cpio,
  findutils,
  gnugrep,
  gnused,
  gnutar,
  gzip,
  lz4,
  lzop,
  squashfsTools,
  util-linux,
  xz,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dracut";
  version = "059";

  src = fetchFromGitHub {
    owner = "dracutdevs";
    repo = "dracut";
    rev = finalAttrs.version;
    hash = "sha256-zSyC2SnSQkmS/mDpBXG2DtVVanRRI9COKQJqYZZCPJM=";
  };

  patches = [
    # dracut-lib.sh moved from 99base to 80base after 059.
    # Required by the CVE-2026-15816 fix below; remove when updating to 112 or newer.
    (fetchpatch2 {
      name = "add-escape-function.patch";
      url = "https://github.com/dracut-ng/dracut/commit/207c339728eff81127469c2f6fe106447c781009.patch?full_index=1";
      relative = "modules.d/80base";
      extraPrefix = "modules.d/99base/";
      hash = "sha256-r8dsJvmb09QH6ZRTceBg3Bo+WbCKA8U7Pj0rAjXDcm4=";
    })
    # Remove when updating to the first release after 112 containing this fix.
    (fetchpatch2 {
      name = "CVE-2026-15816.patch";
      url = "https://github.com/dracut-ng/dracut/commit/c4d555716d569038ca38365741e94ee07908f261.patch?full_index=1";
      relative = "modules.d/80base";
      extraPrefix = "modules.d/99base/";
      hash = "sha256-ja15T++ojzjExRgPjyyuUx/vkLhR9AWBBWgz9hTzHCU=";
    })
  ];

  # Don't create .orig files when the backported patches apply with offsets.
  patchFlags = [
    "--no-backup-if-mismatch"
    "-p1"
  ];

  strictDeps = true;

  buildInputs = [
    bash
    kmod
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    asciidoc
    libxslt
    docbook_xsl
  ];

  postPatch = ''
    substituteInPlace dracut.sh \
      --replace 'dracutbasedir="$dracutsysrootdir"/usr/lib/dracut' 'dracutbasedir="$dracutsysrootdir"'"$out/lib/dracut"
    substituteInPlace lsinitrd.sh \
      --replace 'dracutbasedir=/usr/lib/dracut' "dracutbasedir=$out/lib/dracut"

    echo 'DRACUT_VERSION=${finalAttrs.version}' >dracut-version.sh
  '';

  postFixup = ''
    wrapProgram $out/bin/dracut --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        util-linux
      ]
    } --suffix DRACUT_PATH : ${
      lib.makeBinPath [
        bash
        binutils
        coreutils
        findutils
        gnugrep
        gnused
        gnutar
        stdenv.cc.libc # for ldd command
        util-linux
      ]
    }
    wrapProgram $out/bin/dracut-catimages --set PATH ${
      lib.makeBinPath [
        coreutils
        cpio
        findutils
        gzip
      ]
    }
    wrapProgram $out/bin/lsinitrd --set PATH ${
      lib.makeBinPath [
        binutils
        bzip2
        coreutils
        cpio
        gnused
        gzip
        lz4
        lzop
        squashfsTools
        util-linux
        xz
        zstd
      ]
    }
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/dracutdevs/dracut/wiki";
    description = "Event driven initramfs infrastructure";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
