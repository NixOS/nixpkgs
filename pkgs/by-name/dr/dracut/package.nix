{
  stdenv,
  lib,
  fetchFromGitHub,
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

  # Patch from https://github.com/dracut-ng/dracut/commit/11577739221ff38c1fd29abbba51a6c797376ed6 included in main branch.
  # Adapted to version 111 (line number and small formatting diff)
  patches = [
    ./CVE-2026-6893.patch
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
