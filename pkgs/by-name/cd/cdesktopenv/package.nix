{
  lib,
  stdenv,
  fetchurl,
  libx11,
  bison,
  mksh,
  perl,
  libxinerama,
  libxt,
  libxext,
  libtirpc,
  motif,
  libxft,
  xbitmaps,
  libjpeg,
  libxmu,
  libxdmcp,
  libxscrnsaver,
  bdftopcf,
  ncompress,
  mkfontdir,
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
  libxpm,
  rpcsvc-proto,
  sessreg,
  pkg-config,
  lmdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cde";
  version = "2.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/cdesktopenv/cde-${finalAttrs.version}.tar.gz";
    hash = "sha256-K1jAjr8Ka7nUoyGRzSXiBPXYy6gbzKo2/HL1xKqXmFQ=";
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
      --replace-warn "-I/usr/include/tirpc" "-I${libtirpc.dev}/include/tirpc"

    patchShebangs autogen.sh config.rpath contrib programs
  '';

  buildInputs = [
    libx11
    libxinerama
    libxt
    libxext
    libtirpc
    motif
    libxft
    xbitmaps
    libjpeg
    libxmu
    libxdmcp
    libxscrnsaver
    tcl
    libxaw
    mksh
    libxcrypt
    libxpm
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

  # Can probably remove after next release
  # https://sourceforge.net/p/cdesktopenv/code/ci/f0154141b1f1501490bac8e0235214bf8f00f715/
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

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
})
