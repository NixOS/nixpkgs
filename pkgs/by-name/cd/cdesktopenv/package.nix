{
  lib,
  stdenv,
  fetchurl,
  libX11,
  bison,
  ksh,
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
    mkfontdir
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

  meta = with lib; {
    description = "Common Desktop Environment";
    homepage = "https://sourceforge.net/projects/cdesktopenv/";
    license = licenses.lgpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
