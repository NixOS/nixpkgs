{ sage-src
, perl
, buildPythonPackage
, arb
, openblasCompat
, brial
, cliquer
, cypari2
, cysignals
, cython
, ecl
, eclib
, ecm
, flint
, gd
, givaro
, glpk
, gsl
, iml
, jinja2
, lcalc
, lrcalc
, gap
, linbox
, m4ri
, m4rie
, libmpc
, mpfi
, ntl
, numpy
, pari
, pkgconfig
, pkg-config
, planarity
, ppl
, pynac
, python
, ratpoints
, readline
, rankwidth
, symmetrica
, zn_poly
, fflas-ffpack
, boost
, singular
, pip
, jupyter_core
, libhomfly
, libbraiding
, gmpy2
, pplpy
}:

# This is the core sage python package. Everything else is just wrappers gluing
# stuff together. It is not very useful on its own though, since it will not
# find many of its dependencies without `sage-env`, will not be tested without
# `sage-tests` and will not have html docs without `sagedoc`.

buildPythonPackage rec {
  format = "other";
  version = src.version;
  name = "sagelib-${version}";
  src = sage-src;

  nativeBuildInputs = [
    iml
    perl
    jupyter_core
    pkg-config
    pip # needed to query installed packages
  ];

  buildInputs = [
    gd
    readline
    iml
  ];

  propagatedBuildInputs = [
    cypari2
    jinja2
    numpy
    pkgconfig
    boost
    arb
    brial
    cliquer
    ecl
    eclib
    ecm
    fflas-ffpack
    flint
    givaro
    glpk
    gsl
    lcalc
    gap
    libmpc
    linbox
    lrcalc
    m4ri
    m4rie
    mpfi
    ntl
    openblasCompat
    pari
    planarity
    ppl
    pynac
    rankwidth
    ratpoints
    singular
    symmetrica
    zn_poly
    pip
    cython
    cysignals
    libhomfly
    libbraiding
    gmpy2
    pplpy
  ];

  buildPhase = ''
    export SAGE_ROOT="$PWD"
    export SAGE_LOCAL="$SAGE_ROOT"
    export SAGE_SHARE="$SAGE_LOCAL/share"
    export JUPYTER_PATH="$SAGE_LOCAL/jupyter"

    export PATH="$SAGE_ROOT/build/bin:$SAGE_ROOT/src/bin:$PATH"

    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"

    mkdir -p "$SAGE_SHARE/sage/ext/notebook-ipython"
    mkdir -p "var/lib/sage/installed"

    cd src
    source bin/sage-dist-helpers

    ${python.interpreter} -u setup.py --no-user-cfg build
  '';

  installPhase = ''
    ${python.interpreter} -u setup.py --no-user-cfg install --prefix=$out

    rm -r "$out/${python.sitePackages}/sage/cython_debug"
  '';
}
