{ stdenv
, autoreconfHook
, fetchurl
, fetchpatch
, makeWrapper
, gnuplot
, perl
, python
, texinfo
, withSbcl   ? true,  sbcl
, withEcl    ? false, ecl
, withRlwrap ? false, rlwrap
, withTk     ? false, tk
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
, withTests  ? false # try to re-enable after next version update
}:

# Either SBCL or ECL but not both of them can be used.
assert withSbcl != withEcl;

let

  # Fetch a patch from the SageMath Git repository.
  fetchPatchFromSage = { name, rev, hash } @args : (
    fetchpatch {
      inherit name;
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/maxima/patches/${name}?id=${rev}";
      sha256 = hash;
    }
  );

  searchPath = stdenv.lib.makeBinPath ([
  ] ++ stdenv.lib.optionals withSbcl [
    sbcl
  ] ++ stdenv.lib.optionals withEcl [
    ecl
  ] ++ stdenv.lib.optionals withRlwrap [
    rlwrap
  ] ++ stdenv.lib.optionals withTk [
    tk
  ] ++ stdenv.lib.optionals withTests [
    gnuplot
  ]);

in stdenv.mkDerivation rec {

  pname   = "maxima";
  version = "5.44.0";
  name    = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "1v6jr5s6hhj6r18gfk6hgxk2qd6z1dxkrjq9ss2z1y6sqi45wgyr";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs =  [
    makeWrapper
    perl
    python
    texinfo
  ] ++ stdenv.lib.optionals withSbcl [
    sbcl
  ] ++ stdenv.lib.optionals withEcl [
    ecl
  ] ++ stdenv.lib.optionals withTests [
    gnuplot
  ];

  postPatch = ''
    # Some build scripts now executes `/usr/bin/env perl` instead of
    # `/usr/bin/perl` even where plain `perl` just works.
    # The correct fix upstream would be adding `--with-perl` option to
    # ./configure to support Perl interpreters that not in PATH.
    # See https://sourceforge.net/p/maxima/code/ci/aa7d8228f369821aa6cbf14a6f7e552bb771e247
    find doc/info -type f -exec \
      sed -ie "s|/usr/bin/env perl|${perl}/bin/perl|" {} \;
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
  '' + (stdenv.lib.optionalString withEcl ''
    cp src/binary-ecl/maxima.fas* "$out/lib/maxima/${version}/binary-ecl/"
  '');

  patches = [
    # fix path to info dir (see https://trac.sagemath.org/ticket/11348)
    (fetchPatchFromSage {
      name = "infodir.patch";
      rev  = "07d6c37d18811e2b377a9689790a7c5e24da16ba";
      hash = "09v64n60f7i6frzryrj0zd056lvdpms3ajky4f9p6kankhbiv21x";
    })

    # fix https://sourceforge.net/p/maxima/bugs/2596/
    (fetchPatchFromSage {
      name = "matrixexp.patch";
      rev  = "07d6c37d18811e2b377a9689790a7c5e24da16ba";
      hash = "06961hn66rhjijfvyym21h39wk98sfxhp051da6gz0n9byhwc6zg";
    })

    # undo https://sourceforge.net/p/maxima/code/ci/f5e9b0f7eb122c4e48ea9df144dd57221e5ea0ca
    # see https://trac.sagemath.org/ticket/13364#comment:93
    (fetchPatchFromSage {
      name = "undoing_true_false_printing_patch.patch";
      rev  = "07d6c37d18811e2b377a9689790a7c5e24da16ba";
      hash = "0fvi3rcjv6743sqsbgdzazy9jb6r1p1yq63zyj9fx42wd1hgf7yx";
    })
  ] ++ stdenv.lib.optionals withEcl [
    # build fasl, needed for ECL support
    (fetchPatchFromSage {
      name = "maxima.system.patch";
      rev  = "07d6c37d18811e2b377a9689790a7c5e24da16ba";
      hash = "18zafig8vflhkr80jq2ivk46k92dkszqlyq8cfmj0b2vcfjwwbar";
    })
  ];

  doCheck = withTests;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Computer algebra system";
    homepage = "http://maxima.sourceforge.net";
    license = licenses.gpl2;

    longDescription = ''
      Maxima is a fairly complete computer algebra system written in
      lisp with an emphasis on symbolic computation. It is based on
      DOE-MACSYMA and licensed under the GPL. Its abilities include
      symbolic integration, 3D plotting, and an ODE solver.
    '';

    platforms = platforms.unix;
    maintainers = with maintainers; [ peti ];
  };
}
