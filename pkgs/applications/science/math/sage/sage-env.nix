{ stdenv
, lib
, writeTextFile
, python
, sage-src
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
, gap-libgap-compatible
, libgap
, ecl
, maxima-ecl
, singular
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
, openblas-cblas-pc
, flint
, gmp
, mpfr
, pynac
, zlib
, gsl
, ntl
}:

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
    gap-libgap-compatible
    libgap
    ecl
    maxima-ecl
    singular
    giac
    palp
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
  ]
  ));
in
writeTextFile rec {
  name = "sage-env";
  destination = "/${name}";
  text = ''
    export PKG_CONFIG_PATH='${lib.concatStringsSep ":" (map (pkg: "${pkg}/lib/pkgconfig") [
        # This is only needed in the src/sage/misc/cython.py test and I'm not sure if there's really a use-case
        # for it outside of the tests. However since singular and openblas are runtime dependencies anyways
        # and openblas-cblas-pc is tiny, it doesn't really hurt to include.
        singular
        openblas-cblas-pc
      ])
    }'
    export SAGE_ROOT='${sage-src}'
    export SAGE_LOCAL='@sage-local@'
    export SAGE_SHARE='${sagelib}/share'
    orig_path="$PATH"
    export PATH='${runtimepath}'

    # set dependent vars, like JUPYTER_CONFIG_DIR
    source "${sage-src}/src/bin/sage-env"
    export PATH="${runtimepath}:$orig_path" # sage-env messes with PATH

    export SAGE_LOGS="$TMPDIR/sage-logs"
    export SAGE_DOC="''${SAGE_DOC_OVERRIDE:-doc-placeholder}"
    export SAGE_DOC_SRC="''${SAGE_DOC_SRC_OVERRIDE:-${sage-src}/src/doc}"

    # set locations of dependencies
    . ${env-locations}/sage-env-locations

    # needed for cython
    export CC='${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc'
    # cython needs to find these libraries, otherwise will fail with `ld: cannot find -lflint` or similar
    export LDFLAGS='${
      lib.concatStringsSep " " (map (pkg: "-L${pkg}/lib") [
        flint
        libgap
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
        libgap
        pynac
        mpfr.dev
      ])
    }'

    export SAGE_LIB='${sagelib}/${python.sitePackages}'

    export SAGE_EXTCODE='${sage-src}/src/ext'

    # for find_library
    export DYLD_LIBRARY_PATH="${lib.makeLibraryPath [stdenv.cc.libc singular]}:$DYLD_LIBRARY_PATH"
  '';
}
