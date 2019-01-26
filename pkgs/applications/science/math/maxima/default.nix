{ stdenv, fetchurl, fetchpatch, sbcl, texinfo, perl, python, makeWrapper, rlwrap ? null
, tk ? null, gnuplot ? null, ecl ? null, ecl-fasl ? false
}:

let
  name    = "maxima";
  version = "5.41.0";

  searchPath =
    stdenv.lib.makeBinPath
      (stdenv.lib.filter (x: x != null) [ sbcl ecl rlwrap tk gnuplot ]);
in
stdenv.mkDerivation ({
  inherit version;
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "0x0n81z0s4pl8nwpf7ivlsbvsdphm9w42250g7qdkizl0132by6s";
  };

  buildInputs = stdenv.lib.filter (x: x != null) [
    sbcl ecl texinfo perl python makeWrapper
  ];

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

    # upstream bug https://sourceforge.net/p/maxima/bugs/2520/ (not fixed)
    # introduced in https://trac.sagemath.org/ticket/13364
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/maxima/patches/0001-taylor2-Avoid-blowing-the-stack-when-diff-expand-isn.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "0xa0b6cr458zp7lc7qi0flv5ar0r3ivsqhjl0c3clv86di2y522d";
    })
  ] ++ stdenv.lib.optionals ecl-fasl [
    # build fasl, needed for ECL support
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/maxima/patches/maxima.system.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "18zafig8vflhkr80jq2ivk46k92dkszqlyq8cfmj0b2vcfjwwbar";
    })
    # There are some transient test failures. I hope this disables all those tests.
    # If those test failures ever happen in the non-ecl version, that should be
    # reportetd upstream.
    ./known-ecl-failures.patch
  ];

  # Failures in the regression test suite won't abort the build process. We run
  # the suite only so that potential errors show up in the build log. See also:
  # https://sourceforge.net/tracker/?func=detail&aid=3365831&group_id=4933&atid=104933.
  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Computer algebra system";
    homepage = http://maxima.sourceforge.net;
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
