{ stdenv
, lib
, writeTextFile
, python
, sagelib
, env-locations
, gfortran
, bash
, coreutils
, gnused
, gnugrep
, binutils
, pythonEnv
, python3
, pkg-config
, pari
, gap
, ecl
, maxima-ecl
, singular
, fflas-ffpack
, givaro
, gd
, libpng
, linbox
, m4ri
, giac
, palp
, rWrapper
, gfan
, cddlib
, jmol
, tachyon
, glpk
, eclib
, sympow
, nauty
, sqlite
, ppl
, ecm
, lcalc
, rubiks
, flintqs
, openblasCompat
, flint
, gmp
, mpfr
, pynac
, zlib
, gsl
, ntl
, jdk
, less
}:

# This generates a `sage-env` shell file that will be sourced by sage on startup.
# It sets up various environment variables, telling sage where to find its
# dependencies.

let
  runtimepath = (lib.makeBinPath ([
    "@sage-local@"
    "@sage-local@/build"
    pythonEnv
    # empty python env to add python wrapper that clears PYTHONHOME (see
    # wrapper.nix). This is necessary because sage will call the python3 binary
    # (from python2 code). The python2 PYTHONHOME (again set in wrapper.nix)
    # will then confuse python3, if it is not overwritten.
    python3.buildEnv
    gfortran # for inline fortran
    stdenv.cc # for cython
    bash
    coreutils
    gnused
    gnugrep
    binutils.bintools
    pkg-config
    pari
    gap
    ecl
    maxima-ecl
    singular
    giac
    palp
    # needs to be rWrapper since the default `R` doesn't include R's default libraries
    rWrapper
    gfan
    cddlib
    jmol
    tachyon
    glpk
    eclib
    sympow
    nauty
    sqlite
    ppl
    ecm
    lcalc
    rubiks
    flintqs
    jdk # only needed for `jmol` which may be replaced in the future
    less # needed to prevent transient test errors until https://github.com/ipython/ipython/pull/11864 is resolved
  ]
  ));
in
writeTextFile rec {
  name = "sage-env";
  destination = "/${name}";
  text = ''
    export PKG_CONFIG_PATH='${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
        # This should only be needed during build. However, since the  doctests
        # also test the cython build (for example in src/sage/misc/cython.py),
        # it is also needed for the testsuite to pass. We could fix the
        # testsuite instead, but since all the packages are also runtime
        # dependencies it doesn't really hurt to include them here.
        singular
        openblasCompat
        fflas-ffpack givaro
        gd
        libpng zlib
        gsl
        linbox
        m4ri
      ]
    }'
    export SAGE_ROOT='${sagelib.src}'
    export SAGE_LOCAL='@sage-local@'
    export SAGE_SHARE='${sagelib}/share'
    orig_path="$PATH"
    export PATH='${runtimepath}'

    # set dependent vars, like JUPYTER_CONFIG_DIR
    source "${sagelib.src}/src/bin/sage-env"
    export PATH="$RUNTIMEPATH_PREFIX:${runtimepath}:$orig_path" # sage-env messes with PATH

    export SAGE_LOGS="$TMPDIR/sage-logs"
    export SAGE_DOC="''${SAGE_DOC_OVERRIDE:-doc-placeholder}"
    export SAGE_DOC_SRC="''${SAGE_DOC_SRC_OVERRIDE:-${sagelib.src}/src/doc}"

    # set locations of dependencies
    . ${env-locations}/sage-env-locations

    # needed for cython
    export CC='${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc'
    # cython needs to find these libraries, otherwise will fail with `ld: cannot find -lflint` or similar
    export LDFLAGS='${
      lib.concatStringsSep " " (map (pkg: "-L${pkg}/lib") [
        flint
        gap
        glpk
        gmp
        mpfr
        pari
        pynac
        zlib
        eclib
        gsl
        ntl
        jmol
        sympow
      ])
    }'
    export CFLAGS='${
      lib.concatStringsSep " " (map (pkg: "-isystem ${pkg}/include") [
        singular
        gmp.dev
        glpk
        flint
        gap
        pynac
        mpfr.dev
      ])
    }'

    export SAGE_LIB='${sagelib}/${python.sitePackages}'

    export SAGE_EXTCODE='${sagelib.src}/src/ext'

  # for find_library
    export DYLD_LIBRARY_PATH="${lib.makeLibraryPath [stdenv.cc.libc singular]}''${DYLD_LIBRARY_PATH:+:}$DYLD_LIBRARY_PATH"
  '';
} // {
  lib = sagelib; # equivalent of `passthru`, which `writeTextFile` doesn't support
}
