{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  makeBinaryWrapper,
  pkg-config,
  asciidoctor,
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
  squashfs-tools,
  util-linux,
  xz,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dracut";
  version = "112";

  src = fetchFromGitHub {
    owner = "dracut-ng";
    repo = "dracut";
    tag = finalAttrs.version;
    hash = "sha256-aER+3EbJP3HCBuei+oLHzt/j90fpWj5NgyhMTx3V/YQ=";
  };

  # Remove with the first release containing c4d555716d569038ca38365741e94ee07908f261.
  patches = [
    (fetchpatch2 {
      name = "CVE-2026-15816.patch";
      url = "https://github.com/dracut-ng/dracut/commit/c4d555716d569038ca38365741e94ee07908f261.patch?full_index=1";
      hash = "sha256-UpeoiMyQgvwMNOjX39v0IQSIlwvM+MczyPKPRWmT6vQ=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    bash
    kmod
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
    asciidoctor
    libxslt
    docbook_xsl
  ];

  postPatch = ''
    substituteInPlace dracut.sh \
      --replace-fail "dracutbasedir=\"$""{dracutsysrootdir-}\"/usr/lib/dracut" \
        "if [ -n \"$""{dracutsysrootdir:-}\" ]; then dracutbasedir=\"$""{dracutsysrootdir}/usr/lib/dracut\" ; else dracutbasedir=\"$out/lib/dracut\" ; fi"
    substituteInPlace lsinitrd.sh \
      --replace-fail 'dracutbasedir=/usr/lib/dracut' "dracutbasedir=$out/lib/dracut"

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
        squashfs-tools
        util-linux
        xz
        zstd
      ]
    }
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://dracut-ng.github.io/";
    changelog = "https://github.com/dracut-ng/dracut/blob/${finalAttrs.src.tag}/NEWS.md";
    description = "Event driven initramfs infrastructure";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = lib.platforms.linux;
  };
})
