{
  stdenv,
  lib,
  fetchurl,
  perl,
  gmp,
  gf2x ? null,
  # I asked the ntl maintainer weather or not to include gf2x by default:
  # > If I remember correctly, gf2x is now thread safe, so there's no reason not to use it.
  withGf2x ? true,
  tune ? false, # tune for current system; non reproducible and time consuming
}:

assert withGf2x -> gf2x != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "ntl";
  version = "11.5.1";

  src = fetchurl {
    url = "http://www.shoup.net/ntl/ntl-${finalAttrs.version}.tar.gz";
    hash = "sha256-IQ0GwxMGy8bq9oFEU8Vsd22djo3zbXTrMG9qUj0caoo=";
  };

  strictDeps = true;
  depsBuildBuild = [
    perl # needed for ./configure
  ];
  buildInputs = [
    gmp
  ];

  sourceRoot = "ntl-${finalAttrs.version}/src";

  enableParallelBuilding = true;

  dontAddPrefix = true; # DEF_PREFIX instead

  # Written in perl, does not support autoconf-style
  # --build=/--host= options:
  #   Error: unrecognized option: --build=x86_64-unknown-linux-gnu
  configurePlatforms = [ ];

  # reference: http://shoup.net/ntl/doc/tour-unix.html
  dontAddStaticConfigureFlags = true; # perl config doesn't understand it.
  configureFlags = [
    "DEF_PREFIX=$(out)"
    "NATIVE=off" # don't target code to current hardware (reproducibility, portability)
    "TUNE=${
      if tune then
        "auto"
      else if stdenv.hostPlatform.isx86 then
        "x86" # "chooses options that should be well suited for most x86 platforms"
      else
        "generic" # "chooses options that should be OK for most platforms"
    }"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "AR=${stdenv.cc.targetPrefix}ar"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
    "SHARED=on" # genereate a shared library
  ]
  ++ lib.optionals withGf2x [
    "NTL_GF2X_LIB=on"
    "GF2X_PREFIX=${gf2x}"
  ];

  enableParallelChecking = true;
  doCheck = true; # takes some time

  meta = {
    description = "Library for doing Number Theory";
    longDescription = ''
      NTL is a high-performance, portable C++ library providing data
      structures and algorithms for manipulating signed, arbitrary
      length integers, and for vectors, matrices, and polynomials over
      the integers and over finite fields.
    '';
    # Upstream contact: maintainer is victorshoup on GitHub. Alternatively the
    # email listed on the homepage.
    homepage = "http://www.shoup.net/ntl/";
    # also locally at "${src}/doc/tour-changes.html";
    changelog = "https://www.shoup.net/ntl/doc/tour-changes.html";
    teams = [ lib.teams.sage ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    # Does not cross compile
    # https://github.com/libntl/ntl/issues/8
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
})
