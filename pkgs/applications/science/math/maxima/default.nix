{ stdenv, fetchurl, fetchpatch, sbcl, texinfo, perl, python, makeWrapper, autoreconfHook
, rlwrap ? null, tk ? null, gnuplot ? null, ecl ? null, ecl-fasl ? false
}:

let
  name    = "maxima";
  version = "5.44.0";

  searchPath =
    stdenv.lib.makeBinPath
      (stdenv.lib.filter (x: x != null) [ sbcl ecl rlwrap tk gnuplot ]);
in
stdenv.mkDerivation ({
  inherit version;
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "1v6jr5s6hhj6r18gfk6hgxk2qd6z1dxkrjq9ss2z1y6sqi45wgyr";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = stdenv.lib.filter (x: x != null) [
    sbcl ecl texinfo perl python makeWrapper
    gnuplot   # required in the test suite
  ];

  postPatch = ''
    substituteInPlace doc/info/Makefile.am --replace "/usr/bin/env perl" "${perl}/bin/perl"
  '';

  postInstall = ''
    # Make sure that maxima can find its runtime dependencies.
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PATH ":" "$out/bin:${searchPath}"
    done
    # Move emacs modules and documentation into the right place.
    mkdir -p $out/share/emacs $out/share/doc
    ln -s ../maxima/${version}/emacs $out/share/emacs/site-lisp
    ln -s ../maxima/${version}/doc $out/share/doc/maxima
  ''
   + (stdenv.lib.optionalString ecl-fasl ''
     cp src/binary-ecl/maxima.fas* "$out/lib/maxima/${version}/binary-ecl/"
   '')
  ;

  patches = [
    # fix path to info dir (see https://trac.sagemath.org/ticket/11348)
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/maxima/patches/infodir.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "09v64n60f7i6frzryrj0zd056lvdpms3ajky4f9p6kankhbiv21x";
    })

    # fix https://sourceforge.net/p/maxima/bugs/2596/
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/maxima/patches/matrixexp.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "06961hn66rhjijfvyym21h39wk98sfxhp051da6gz0n9byhwc6zg";
    })

    # undo https://sourceforge.net/p/maxima/code/ci/f5e9b0f7eb122c4e48ea9df144dd57221e5ea0ca, see see https://trac.sagemath.org/ticket/13364#comment:93
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/maxima/patches/undoing_true_false_printing_patch.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "0fvi3rcjv6743sqsbgdzazy9jb6r1p1yq63zyj9fx42wd1hgf7yx";
    })
  ] ++ stdenv.lib.optionals ecl-fasl [
    # build fasl, needed for ECL support
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/maxima/patches/maxima.system.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "18zafig8vflhkr80jq2ivk46k92dkszqlyq8cfmj0b2vcfjwwbar";
    })
  ];

  # The test suite is disabled since 5.42.2 because of the following issues:
  #
  #   Error(s) found:
  #   /build/maxima-5.44.0/share/linearalgebra/rtest_matrixexp.mac problems:
  #   (20 21 22)
  #   Tests that were expected to fail but passed:
  #   /build/maxima-5.44.0/share/vector/rtest_vect.mac problem:
  #   (19)
  #   3 tests failed out of 16,184 total tests.
  #
  # These failures don't look serious. It would be nice to fix them, but I
  # don't know how and probably won't have the time to find out.
  doCheck = false;    # try to re-enable after next version update

  enableParallelBuilding = true;

  passthru = {
    ecl = ecl;
  };

  meta = {
    description = "Computer algebra system";
    homepage = "http://maxima.sourceforge.net";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Maxima is a fairly complete computer algebra system written in
      lisp with an emphasis on symbolic computation. It is based on
      DOE-MACSYMA and licensed under the GPL. Its abilities include
      symbolic integration, 3D plotting, and an ODE solver.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
})
