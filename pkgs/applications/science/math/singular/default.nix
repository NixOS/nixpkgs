{ stdenv, fetchurl, gmp, bison, perl, ncurses, readline, coreutils, pkgconfig
, lib
, fetchpatch
, autoreconfHook
, sharutils
, file
, flint
, ntl
, cddlib
, enableGfanlib ? true
}:

stdenv.mkDerivation rec {
  name = "singular-${version}";
  version = "4.1.1p3";

  # singular sorts its tarballs in directories by base release (without patch version)
  # for example 4.1.1p1 will be in the directory 4-1-1
  baseVersion = builtins.head (lib.splitString "p" version);
  urlVersion = builtins.replaceStrings [ "." ] [ "-" ] baseVersion;
  src = fetchurl {
    url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${urlVersion}/singular-${version}.tar.gz";
    sha256 = "1qqj9bm9pkzm0iyycpvm8x6s79wws3nq60lz25h8x1q61h3426sm";
  };
  tests = fetchurl {
    url = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/${urlVersion}/singular-tst-${version}.tar.gz";
    sha256 = "10w3iabx0ykxwfk07n3z752jinan425wkp00f74nkv745bfhz139";
  };

  configureFlags = [
    "--with-ntl=${ntl}"
  ] ++ lib.optionals enableGfanlib [
    "--enable-gfanlib"
  ];

  prePatch = ''
    # move Tests into singular source root
    tar xf "${tests}"

    # don't let the tests depend on `hostname`
    substituteInPlace Tst/regress.cmd --replace 'mysystem_catch("hostname")' 'nix_test_runner'

    patchShebangs .
  '';

  patches = [
    # Fix bug with gcd in Z[x]
    # https://www.singular.uni-kl.de:8005/trac/ticket/834
    (fetchpatch {
      name = "gcd-fix.patch";
      url = "https://github.com/Singular/Sources/commit/55ec4f789df5836f21154a2d6e25c0e9cb8cf814.patch";
      sha256 = "1jy5gngdh8xawbbh59w6fnks22h778wpaqvzpq4h2l7xhz7dgdnb";
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
    sharutils # needed for regress.cmd install checks
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

  doCheck = true; # very basic checks, does not test any libraries

  installPhase = ''
    mkdir -p "$out"
    cp -r Singular/LIB "$out/lib"
    make install

    # Make sure patchelf picks up the right libraries
    rm -rf libpolys factory resources omalloc Singular
  '';

  # singular tests are a bit complicated, see
  # https://github.com/Singular/Sources/tree/spielwiese/Tst
  # https://www.singular.uni-kl.de/forum/viewtopic.php&t=2773
  testsToRun = [
    "Old/universal.lst"
    "Buch/buch.lst"
    "Plural/short.lst"
    "Old/factor.tst"
  ] ++ lib.optionals enableGfanlib [
    # tests that require gfanlib
    "Short/ok_s.lst"
  ];

  # simple test to make sure singular starts and finds its libraries
  doInstallCheck = true;
  installCheckPhase = ''
    # Very basic sanity check to make sure singular starts and finds its libraries.
    # This is redundant with the below tests. It is only kept because the singular test
    # runner is a bit complicated. In case we decide to give up those tests in the future,
    # this will still be useful. It takes barely any time.
    "$out/bin/Singular" -c 'LIB "freegb.lib"; exit;'
    if [ $? -ne 0 ]; then
        echo >&2 "Error loading the freegb library in Singular."
        exit 1
    fi

    # Run the test suite
    cd Tst
    perl ./regress.cmd \
      -s "$out/bin/Singular" \
      ${lib.concatStringsSep " " (map lib.escapeShellArg testsToRun)} \
      2>"$TMPDIR/out-err.log"

    # unfortunately regress.cmd always returns exit code 0, so check stderr
    # https://www.singular.uni-kl.de/forum/viewtopic.php&t=2773
    if [[ -s "$TMPDIR/out-err.log" ]]; then
      cat "$TMPDIR/out-err.log"
      exit 1
    fi

    echo "Exit status $?"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A CAS for polynomial computations";
    maintainers = with maintainers; [ raskin timokau ];
    # 32 bit x86 fails with some link error: `undefined reference to `__divmoddi4@GCC_7.0.0'`
    # https://www.singular.uni-kl.de:8002/trac/ticket/837
    platforms = subtractLists platforms.i686 platforms.linux;
    license = licenses.gpl3; # Or GPLv2 at your option - but not GPLv4
    homepage = http://www.singular.uni-kl.de;
    downloadPage = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/";
  };
}
