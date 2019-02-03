{ stdenv
, lib
, sage-src
, makePythonWrapper
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

, pari_data
, conway_polynomials
, graphs
, elliptic_curves
, polytopes_db
, combinatorial_designs
, mathjax
, three
, cysignals
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
  ]
  ));

  set = {
    "PKG_CONFIG_PATH" = lib.concatStringsSep ":" (map (pkg: "${pkg}/lib/pkgconfig") [
        # This is only needed in the src/sage/misc/cython.py test and I'm not
        # sure if there's really a usecase for it outside of the tests. However
        # since singular and openblas are runtime dependencies anyways, it doesn't
        # really hurt to include.
        singular
        openblasCompat
      ]);
    "SAGE_ROOT" = sagelib.src;
    "SAGE_SRC" = "${sagelib.src}/src";
    "SAGE_LOCAL" = "${placeholder "out"}";
    "SAGE_SHARE" = "${sagelib}/share";
    "SAGE_DOC" = "doc-placeholder";
    "SAGE_DOC_SRC" = "${sagelib.src}/src/doc";
    # needed for cython
    "CC" = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
    # cython needs to find these libraries, otherwise will fail with `ld: cannot find -lflint` or similar
    "LDFLAGS" = lib.concatStringsSep " " (map (pkg: "-L${pkg}/lib") [
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
    ]);
    "CFLAGS" = lib.concatStringsSep " " (map (pkg: "-isystem ${pkg}/include") [
      singular
      gmp.dev
      glpk
      flint
      gap
      pynac
      mpfr.dev
    ]);
    "SAGE_LIB" = "${sagelib}/${python.sitePackages}";
    "SAGE_EXTCODE" = "${sagelib.src}/src/ext";

    "GP_DATA_DIR" = "${pari_data}/share/pari";
    "PARI_DATA_DIR" = "${pari_data}";
    "GPHELP" = "${pari}/bin/gphelp";
    "GPDOCDIR" = "${pari}/share/pari/doc";
    "SINGULARPATH" = "${singular}/share/singular";
    "SINGULAR_SO" = "${singular}/lib/libSingular.so";
    "SINGULAR_EXECUTABLE" = "${singular}/bin/Singular";
    "MAXIMA_FAS" = "${maxima-ecl}/lib/maxima/${maxima-ecl.version}/binary-ecl/maxima.fas";
    "MAXIMA_PREFIX" = "${maxima-ecl}";
    "CONWAY_POLYNOMIALS_DATA_DIR" = "${conway_polynomials}/share/conway_polynomials";
    "GRAPHS_DATA_DIR" = "${graphs}/share/graphs";
    "ELLCURVE_DATA_DIR" = "${elliptic_curves}/share/ellcurves";
    "POLYTOPE_DATA_DIR" = "${polytopes_db}/share/reflexive_polytopes";
    "GAP_ROOT_DIR" = "${gap}/share/gap/build-dir";
    "ECLDIR" = "${ecl}/lib/ecl-${ecl.version}/";
    "COMBINATORIAL_DESIGN_DATA_DIR" = "${combinatorial_designs}/share/combinatorial_designs";
    "CREMONA_MINI_DATA_DIR" = "${elliptic_curves}/share/cremona";
    "JMOL_DIR" = "${jmol}/share/jmol"; # point to the directory that contains JmolData.jar
    "JSMOL_DIR" = "${jmol}/share/jsmol";
    "MATHJAX_DIR" = "${mathjax}/lib/node_modules/mathjax";
    "THREEJS_DIR" = "${three}/lib/node_modules/three";
    "SAGE_INCLUDE_DIRECTORIES" = "${cysignals}/lib/python2.7/site-packages";
  };
  prefix = {
    "PATH" = runtimepath;
    # for find_library
    "DYLD_LIBRARY_PATH" = lib.makeLibraryPath [stdenv.cc.libc singular];
  };
  code = ''
    os.environ['DOT_SAGE'] = '{}/.sage'.format(os.environ['HOME'])
    os.environ['SAGE_LOGS'] = '{}/sage-logs'.format(os.environ.get('TMPDIR', '/tmp'))
  '';
in
  (makePythonWrapper {
    packageToWrap = sagelib;
    module_name = "sage";
    inherit prefix set code;
    extraInstall = ''
      mkdir -p "$out/var/lib/sage/installed"
      for pkg in ${lib.concatStringsSep " " []}; do
        touch "$out/var/lib/sage/installed/$pkg"
      done

      mkdir -p "$out/etc"
      # sage tests will try to create this file if it doesn't exist
      touch "$out/etc/sage-started.txt"

      mkdir -p "$out/build"

      # the scripts in src/bin will find the actual sage source files using environment variables set in `sage-env`
      cp -r ${sage-src}/src/bin "$out/bin"
      cp -r ${sage-src}/build/bin "$out/build/bin"
    '';
  }) // {
    lib = sagelib; # equivalent of `passthru`, which `writeTextFile` doesn't support
  }
