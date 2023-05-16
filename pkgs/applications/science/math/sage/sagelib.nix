{ sage-src
, env-locations
<<<<<<< HEAD
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
, arb
, blas
, boost
, brial
, cliquer
, eclib
, ecm
, fflas-ffpack
, flint
, gap
=======
, perl
, buildPythonPackage
, m4
, arb
, blas
, lapack
, brial
, cliquer
, cypari2
, cysignals
, cython
, lisp-compiler
, eclib
, ecm
, flint
, gd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, giac
, givaro
, glpk
, gsl
<<<<<<< HEAD
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
, cvxopt
, cypari2
, cysignals
, cython
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
=======
, iml
, jinja2
, libpng
, lcalc
, lrcalc
, gap
, linbox
, m4ri
, m4rie
, memory-allocator
, libmpc
, mpfi
, ntl
, numpy
, pari
, pkgconfig # the python module, not the pkg-config alias
, pkg-config
, planarity
, ppl
, primecountpy
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
, jupyter-core
, sage-setup
, libhomfly
, libbraiding
, gmpy2
, pplpy
, sqlite
, jupyter-client
, ipywidgets
, mpmath
, rpy2
, fpylll
, scipy
, sympy
, matplotlib
, pillow
, ipykernel
, networkx
, ptyprocess
, lrcalc-python
, sphinx # TODO: this is in setup.cfg, should we override it?
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeBuildInputs = [
    iml
<<<<<<< HEAD
    lisp-compiler
    m4
    perl
    pip # needed to query installed packages
    pkg-config
    sage-setup
=======
    perl
    jupyter-core
    pkg-config
    sage-setup
    pip # needed to query installed packages
    lisp-compiler
    m4
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    gd
<<<<<<< HEAD
    iml
    libpng
    readline
  ];

  propagatedBuildInputs = [
    # native dependencies (TODO: determine which ones need to be propagated)
    arb
    blas
    boost
    brial
    cliquer
=======
    readline
    iml
    libpng
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
    lisp-compiler
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    eclib
    ecm
    fflas-ffpack
    flint
<<<<<<< HEAD
    gap
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    giac
    givaro
    glpk
    gsl
<<<<<<< HEAD
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
    cvxopt
    cypari2
    cysignals
    cython
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
=======
    lcalc
    gap
    libmpc
    linbox
    lrcalc
    m4ri
    m4rie
    memory-allocator
    mpfi
    ntl
    blas
    lapack
    pari
    planarity
    ppl
    primecountpy
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
    sqlite
    mpmath
    rpy2
    scipy
    sympy
    matplotlib
    pillow
    ipykernel
    fpylll
    networkx
    jupyter-client
    ipywidgets
    ptyprocess
    lrcalc-python
    sphinx
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

    cd build/pkgs/sagelib

    # some files, like Pipfile, pyproject.toml, requirements.txt and setup.cfg
    # are generated by the bootstrap script using m4. these can fetch data from
    # build/pkgs, either directly or via sage-get-system-packages.
    sed -i '/sage_conf/d' src/setup.cfg.m4
    sed -i '/sage_conf/d' src/requirements.txt.m4

    # version lower bounds are useful, but upper bounds are a hassle because
    # Sage tests already catch any relevant API breakage.
    # according to the discussion at https://trac.sagemath.org/ticket/33520,
    # upper bounds will be less noisy starting from Sage 9.6.
    sed -i 's/==0.5.1/>=0.5.1/' ../ptyprocess/install-requires.txt
    sed -i 's/, <[^, ]*//' ../*/install-requires.txt

    for infile in src/*.m4; do
        if [ -f "$infile" ]; then
            outfile="src/$(basename $infile .m4)"
            m4 "$infile" > "$outfile"
        fi
    done

    cd src
  '';

  postInstall = ''
    rm -r "$out/${python.sitePackages}/sage/cython_debug"
  '';

  doCheck = false; # we will run tests in sage-tests.nix
}
