{
  lib,
  stdenv,
  fetchurl,
  libx11,
  bison,
  ksh,
  perl,
  libXinerama,
  libXt,
  libxext,
  libtirpc,
  motif,
  libxft,
  xbitmaps,
  libjpeg,
  libXmu,
  libxdmcp,
  libXScrnSaver,
  bdftopcf,
  ncompress,
  mkfontscale,
  tcl,
  libxaw,
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
}:

stdenv.mkDerivation rec {
  pname = "cde";
  version = "2.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/cdesktopenv/cde-${version}.tar.gz";
    hash = "sha256-caslezz2kbljwApv5igDPH345PK2YqQUTi1YZgvM1Dw=";
  };

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
      --replace "-I/usr/include/tirpc" "-I${libtirpc.dev}/include/tirpc"

    patchShebangs autogen.sh config.rpath contrib programs
  '';

  buildInputs = [
    libx11
    libXinerama
    libXt
    libxext
    libtirpc
    motif
    libxft
    xbitmaps
    libjpeg
    libXmu
    libxdmcp
    libXScrnSaver
    tcl
    libxaw
    ksh
    libxcrypt
    libXpm
  ];
  nativeBuildInputs = [
    bison
    ncompress
    autoPatchelfHook
    makeWrapper
    autoreconfHook
    bdftopcf
    mkfontscale
    xset
    xrdb
    opensp
    perl
    flex
    rpcsvc-proto
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
