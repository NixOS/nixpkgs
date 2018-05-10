{ stdenv, fetchurl, gmp, bison, perl, autoconf, ncurses, readline, coreutils, pkgconfig
, autoreconfHook
, file
, flint
, ntl
, cddlib
, enableFactory ? true
, enableGfanlib ? true
}:

stdenv.mkDerivation rec {
  name = "singular-${version}${patchVersion}";
  version = "4.1.1";
  patchVersion = "p1";

  urlVersion = builtins.replaceStrings [ "." ] [ "-" ] version;
  src = fetchurl {
    url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${urlVersion}/singular-${version}${patchVersion}.tar.gz";
    sha256 = "0wvgz7l1b7zkpmim0r3mvv4fp8xnhlbz4c7hc90rn30snlansnf1";
  };

  configureFlags = [
    "--with-ntl=${ntl}"
  ] ++stdenv.lib.optionals enableFactory [
    "--enable-factory"
  ] ++ stdenv.lib.optionals enableGfanlib [
    "--enable-gfanlib"
  ];

  postUnpack = ''
    patchShebangs .
  '';

  # For reference (last checked on commit 75f460d):
  # https://github.com/Singular/Sources/blob/spielwiese/doc/Building-Singular-from-source.md
  # https://github.com/Singular/Sources/blob/spielwiese/doc/external-packages-dynamic-modules.md
  buildInputs = [
    # necessary
    gmp
    # by upstream recommended but optional
    ncurses
    readline
    ntl
    flint
  ] ++ stdenv.lib.optionals enableGfanlib [
    cddlib
  ];
  nativeBuildInputs = [
    bison
    perl
    pkgconfig
    autoreconfHook
  ];

  preAutoreconf = ''
    find . -type f -readable -writable -exec sed \
      -e 's@/bin/rm@${coreutils}&@g' \
      -e 's@/bin/uname@${coreutils}&@g' \
      -e 's@/usr/bin/file@${file}/bin/file@g' \
      -i '{}' ';'
  '';

  hardeningDisable = stdenv.lib.optional stdenv.isi686 "stackprotector";

  # The Makefile actually defaults to `make install` anyway
  buildPhase = "true;";

  installPhase = ''
    mkdir -p "$out"
    cp -r Singular/LIB "$out/lib"
    make install

    # Make sure patchelf picks up the right libraries
    rm -rf libpolys factory resources omalloc Singular
  '';

  # simple test to make sure singular starts and finds its libraries
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/Singular -c 'LIB "freegb.lib"; exit;'
    if [ $? -ne 0 ]; then
        echo >&2 "Error loading the freegb library in Singular."
        exit 1
    fi
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A CAS for polynomial computations";
    maintainers = with maintainers; [ raskin ];
    platforms = subtractLists platforms.i686 platforms.linux;
    license = licenses.gpl3; # Or GPLv2 at your option - but not GPLv4
    homepage = http://www.singular.uni-kl.de;
    downloadPage = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/";
  };
}
