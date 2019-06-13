{ stdenv, fetchurl, gmp, bison, perl, ncurses, readline, coreutils, pkgconfig
, lib
, fetchpatch
, autoreconfHook
, file
, flint
, ntl
, cddlib
, enableFactory ? true
, enableGfanlib ? true
}:

stdenv.mkDerivation rec {
  name = "singular-${version}";
  version = "4.1.1p2";

  src = let
    # singular sorts its tarballs in directories by base release (without patch version)
    # for example 4.1.1p1 will be in the directory 4-1-1
    baseVersion = builtins.head (lib.splitString "p" version);
    urlVersion = builtins.replaceStrings [ "." ] [ "-" ] baseVersion;
  in
  fetchurl {
    url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${urlVersion}/singular-${version}.tar.gz";
    sha256 = "07x9kri8vl4galik7lr6pscq3c51n8570pyw64i7gbj0m706f7wf";
  };

  configureFlags = [
    "--with-ntl=${ntl}"
  ] ++ lib.optionals enableFactory [
    "--enable-factory"
  ] ++ lib.optionals enableGfanlib [
    "--enable-gfanlib"
  ];

  postUnpack = ''
    patchShebangs .
  '';

  patches = [
    # NTL error handler was introduced in the library part, preventing users of
    # the library from implementing their own error handling
    # https://www.singular.uni-kl.de/forum/viewtopic.php?t=2769
    (fetchpatch {
      name = "move_error_handler_out_of_libsingular.patch";
      # rebased version of https://github.com/Singular/Sources/commit/502cf86d0bb2a96715be6764774b64a69c1ca34c.patch
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/singular/patches/singular-ntl-error-handler.patch?h=50b9ae2fd233c30860e1cbb3e63a26f2cc10560a";
      sha256 = "0vgh4m9zn1kjl0br68n04j4nmn5i1igfn28cph0chnwf7dvr9194";
    })
  ];

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
  ] ++ lib.optionals enableGfanlib [
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

  hardeningDisable = lib.optional stdenv.isi686 "stackprotector";

  # The Makefile actually defaults to `make install` anyway
  buildPhase = ''
    # do nothing
  '';

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
    "$out/bin/Singular" -c 'LIB "freegb.lib"; exit;'
    if [ $? -ne 0 ]; then
        echo >&2 "Error loading the freegb library in Singular."
        exit 1
    fi
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A CAS for polynomial computations";
    maintainers = with maintainers; [ raskin timokau ];
    # 32 bit x86 fails with some link error: `undefined reference to `__divmoddi4@GCC_7.0.0'`
    platforms = subtractLists platforms.i686 platforms.linux;
    license = licenses.gpl3; # Or GPLv2 at your option - but not GPLv4
    homepage = http://www.singular.uni-kl.de;
    downloadPage = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/";
  };
}
