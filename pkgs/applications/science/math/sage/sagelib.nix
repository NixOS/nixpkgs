{ sage-src
, env-locations
, python
, buildPythonPackage
, m4
, perl
, pkg-config
, sage-setup
, gd
, iml
, libpng
, readline
, blas
, boost
, brial
, cliquer
, eclib
, ecm
, fflas-ffpack
, flint3
, gap
, giac
, givaro
, glpk
, gsl
, lapack
, lcalc
, libbraiding
, libhomfly
, libmpc
, linbox
, lisp-compiler
, lrcalc
, m4ri
, m4rie
, mpfi
, mpfr
, ntl
, pari
, planarity
, ppl
, rankwidth
, ratpoints
, singular
, sqlite
, symmetrica
, conway-polynomials
, cvxopt
, cypari2
, cysignals
, cython_3
, fpylll
, gmpy2
, importlib-metadata
, importlib-resources
, ipykernel
, ipython
, ipywidgets
, jinja2
, jupyter-client
, jupyter-core
, lrcalc-python
, matplotlib
, memory-allocator
, mpmath
, networkx
, numpy
, pexpect
, pillow
, pip
, pkgconfig
, pplpy
, primecountpy
, ptyprocess
, requests
, rpy2
, scipy
, sphinx
, sympy
, typing-extensions
, nbclassic
}:

assert (!blas.isILP64) && (!lapack.isILP64);

# This is the core sage python package. Everything else is just wrappers gluing
# stuff together. It is not very useful on its own though, since it will not
# find many of its dependencies without `sage-env`, will not be tested without
# `sage-tests` and will not have html docs without `sagedoc`.

buildPythonPackage rec {
  version = src.version;
  pname = "sagelib";
  src = sage-src;
  pyproject = true;

  nativeBuildInputs = [
    iml
    lisp-compiler
    m4
    perl
    pip # needed to query installed packages
    pkg-config
    sage-setup
  ];

  buildInputs = [
    gd
    iml
    libpng
    readline
  ];

  propagatedBuildInputs = [
    # native dependencies (TODO: determine which ones need to be propagated)
    blas
    boost
    brial
    cliquer
    eclib
    ecm
    fflas-ffpack
    flint3
    gap
    giac
    givaro
    glpk
    gsl
    lapack
    lcalc
    libbraiding
    libhomfly
    libmpc
    linbox
    lisp-compiler
    lrcalc
    m4ri
    m4rie
    mpfi
    mpfr
    ntl
    pari
    planarity
    ppl
    rankwidth
    ratpoints
    singular
    sqlite
    symmetrica

    # from src/sage/setup.cfg and requirements.txt
    conway-polynomials
    cvxopt
    cypari2
    cysignals
    cython_3
    fpylll
    gmpy2
    importlib-metadata
    importlib-resources
    ipykernel
    ipython
    ipywidgets
    jinja2
    jupyter-client
    jupyter-core
    lrcalc-python
    matplotlib
    memory-allocator
    mpmath
    networkx
    numpy
    pexpect
    pillow
    pip
    pkgconfig
    pplpy
    primecountpy
    ptyprocess
    requests
    rpy2
    scipy
    sphinx
    sympy
    typing-extensions

    nbclassic
  ];

  preBuild = ''
    export SAGE_ROOT="$PWD"
    export SAGE_LOCAL="$SAGE_ROOT"
    export SAGE_SHARE="$SAGE_LOCAL/share"

    # set locations of dependencies (needed for nbextensions like threejs)
    . ${env-locations}/sage-env-locations

    export JUPYTER_PATH="$SAGE_LOCAL/jupyter"
    export PATH="$SAGE_ROOT/build/bin:$SAGE_ROOT/src/bin:$PATH"

    export SAGE_NUM_THREADS="$NIX_BUILD_CORES"

    mkdir -p "$SAGE_SHARE/sage/ext/notebook-ipython"
    mkdir -p "var/lib/sage/installed"

    sed -i "/sage-conf/d" src/{setup.cfg,pyproject.toml,requirements.txt}

    cd build/pkgs/sagelib/src
  '';

  postInstall = ''
    rm -r "$out/${python.sitePackages}/sage/cython_debug"
  '';

  doCheck = false; # we will run tests in sage-tests.nix
}
