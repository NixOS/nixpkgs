{
  lib,
  stdenv,
  fetchgit,
  libX11,
  bison,
  mksh,
  perl,
  libXinerama,
  libXt,
  libXext,
  libtirpc,
  motif,
  libXft,
  xbitmaps,
  libjpeg,
  libXmu,
  libXdmcp,
  libXScrnSaver,
  bdftopcf,
  ncompress,
  mkfontdir,
  tcl,
  libXaw,
  libxcrypt,
  glibcLocales,
  autoPatchelfHook,
  makeWrapper,
  xset,
  xrdb,
  autoreconfHook,
  opensp,
  flex,
  libXpm,
  rpcsvc-proto,
  sessreg,
  pkg-config,
  lmdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cde";
  version = "2.5.2-23-gbb0a127a8";

  src = fetchgit {
    url = "https://git.code.sf.net/p/cdesktopenv/code";
    rev = "bb0a127a847f21de400bef038ff6a9c2153096c4";
    hash = "sha256-57m7m5fvkstSnuNnEU2Y51uwgyvbTZ4IV6c4kj51PA4=";
  };

  sourceRoot = "${finalAttrs.src.name}/cde";

  postPatch = ''
    for f in $(find . -type f ! -path doc/common); do
      sed -i \
        -e "s|/usr/dt|$out|g" \
        -e "s|/etc/dt|$out/etc|g" \
        -e "s|\$(DESTDIR)/var|$out/var|g" \
        "$f"
    done

    for f in $(find . -type f -name "Makefile.am"); do
      sed -i \
        -e "/chown /d" \
        -e "/chgrp /d" \
        -e "s/chmod 4755/chmod 755/g" \
        "$f"
    done

    substituteInPlace configure.ac \
      --replace-warn "-I/usr/include/tirpc" "-I${libtirpc.dev}/include/tirpc"

    patchShebangs autogen.sh config.rpath contrib programs
  '';

  buildInputs = [
    libX11
    libXinerama
    libXt
    libXext
    libtirpc
    motif
    libXft
    xbitmaps
    libjpeg
    libXmu
    libXdmcp
    libXScrnSaver
    tcl
    libXaw
    mksh
    libxcrypt
    libXpm
    sessreg
    lmdb
  ];
  nativeBuildInputs = [
    bison
    ncompress
    autoPatchelfHook
    makeWrapper
    autoreconfHook
    bdftopcf
    mkfontdir
    xset
    xrdb
    opensp
    perl
    flex
    rpcsvc-proto
    pkg-config
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
  '';

  configureFlags = [
    "--with-tcl=${tcl}/lib"
  ];

  preInstall = ''
    mkdir -p $out/opt/dt/bin
  '';

  meta = {
    description = "Common Desktop Environment";
    homepage = "https://sourceforge.net/projects/cdesktopenv/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
  };
})
