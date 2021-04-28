{ stdenv, fetchFromGitHub, gmp, bison, perl, ncurses, readline, coreutils, pkg-config
, lib
, fetchpatch
, autoreconfHook
, sharutils
, file
, flint
, ntl
, cddlib
, gfan
, lrcalc
, doxygen
, graphviz
# upstream generates docs with texinfo 4. later versions of texinfo
# use letters instead of numbers for post-appendix chapters, and we
# want it to match the upstream format because sage depends on it.
, texinfo4
, texlive
, enableDocs ? true
, enableGfanlib ? true
}:

stdenv.mkDerivation rec {
  pname = "singular";
  version = "4.2.0p2";

  # since the tarball does not contain tests or documentation (and
  # there is no separate tests tarball for 4.2.0), we fetch from
  # GitHub.
  src = fetchFromGitHub {
    owner = "Singular";
    repo = "Singular";

    # 4.2.0p2 is not tagged, but the tarball matches commit
    # 6f68939ddf612d96e3caaaaa8275f77613ac1da8. the commit below has
    # two extra fixes.
    rev = "3cda50c00a849455efa2502e56596955491a353a";
    sha256 = "sha256-OizPhGE6L2LTOrKfeDdDB6BSdvYkDVXvbbYjV14hnHM=";

    # if a release is tagged it will be in the format below.
    # rev = "Release${lib.replaceStrings ["."] ["-"] version}";

    # the repository's .gitattributes file contains the lines "/Tst/
    # export-ignore" and "/doc/ export-ignore" so some directories are
    # not included in the tarball downloaded by fetchzip. setting
    # fetchSubmodules works around this by using fetchgit instead of
    # fetchzip.
    fetchSubmodules = true;
  };

  patches = [
    # add aarch64 support to cpu-check.m4. copied from redhat.
    ./redhat-aarch64.patch

    # vspace causes hangs in modstd and other libraries on aarch64
    ./disable-vspace-on-aarch64.patch

    # the newest version of ax-prog-cc-for-build.m4 seems to trigger
    # linker errors. see
    # https://github.com/alsa-project/alsa-firmware/issues/3 for a
    # related issue.
    ./use-older-ax-prog-cc-for-build.patch
  ] ++ lib.optionals enableDocs [
    # singular supports building without 4ti2, bertini, normaliz or
    # topcom just fine, but the docbuilding does not skip manual pages
    # tagged as depending on those binaries (probably a bug in
    # doc2tex.pl::HandleLib, since it seems to ignore "-exclude"
    # argumens). skip them manually.
    ./disable-docs-for-optional-unpackaged-deps.patch
  ];

  configureFlags = [
    "--with-ntl=${ntl}"
    "--disable-pyobject-module"
  ] ++ lib.optionals enableDocs [
    "--enable-doc-build"
  ] ++ lib.optionals enableGfanlib [
    "--enable-gfanlib"
  ];

  prePatch = ''
    # don't let the tests depend on `hostname`
    substituteInPlace Tst/regress.cmd --replace 'mysystem_catch("hostname")' 'nix_test_runner'

    patchShebangs .
  '' + lib.optionalString enableDocs ''
    # work around encoding problem
    sed -i -e 's/\xb7/@cdot{}/g' doc/decodegb.doc
  '';

  # For reference (last checked on commit 75f460d):
  # https://github.com/Singular/Singular/blob/spielwiese/doc/Building-Singular-from-source.md
  # https://github.com/Singular/Singular/blob/spielwiese/doc/external-packages-dynamic-modules.md
  buildInputs = [
    # necessary
    gmp
    # by upstream recommended but optional
    ncurses
    readline
    ntl
    flint
    lrcalc
    gfan
  ] ++ lib.optionals enableGfanlib [
    cddlib
  ];
  nativeBuildInputs = [
    bison
    perl
    pkg-config
    autoreconfHook
    sharutils # needed for regress.cmd install checks
  ] ++ lib.optionals enableDocs [
    doxygen
    graphviz
    texinfo4
    texlive.combined.scheme-small
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
  '' + lib.optionalString enableDocs ''
    # Sage uses singular.hlp (which is not in the tarball)
    mkdir -p $out/share/info
    cp doc/singular.hlp $out/share/info
  '' + ''
    # Make sure patchelf picks up the right libraries
    rm -rf libpolys factory resources omalloc Singular
  '';

  # singular tests are a bit complicated, see
  # https://github.com/Singular/Singular/tree/spielwiese/Tst
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
    maintainers = teams.sage.members;
    # 32 bit x86 fails with some link error: `undefined reference to `__divmoddi4@GCC_7.0.0'`
    # https://www.singular.uni-kl.de:8002/trac/ticket/837
    platforms = subtractLists platforms.i686 platforms.unix;
    license = licenses.gpl3; # Or GPLv2 at your option - but not GPLv4
    homepage = "http://www.singular.uni-kl.de";
    downloadPage = "http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/";
  };
}
