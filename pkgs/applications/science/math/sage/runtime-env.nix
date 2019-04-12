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
}:

# Various environment variables sage needs at runtime.

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
]));
in
{
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
    "SAGE_LOCAL" = "@sage-local@";
    "SAGE_SHARE" = "${sagelib}/share";
    "SAGE_LOGS" = "$TMPDIR/sage-logs";
    "SAGE_DOC" = ''''${SAGE_DOC_OVERRIDE:-doc-placeholder}'';
    "SAGE_DOC_SRC" = ''''${SAGE_DOC_SRC_OVERRIDE:-${sagelib.src}/src/doc}'';
    "DOT_SAGE" = "$HOME/.sage";
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

  };
  prefix = {
    "PATH" = runtimepath;
    # for find_library
    "DYLD_LIBRARY_PATH" = lib.makeLibraryPath [stdenv.cc.libc singular];
  };
}
