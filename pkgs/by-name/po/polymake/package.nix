{
  lib,
  stdenv,
  fetchurl,
  gmp,
  mpfr,
  flint,
  boost,
  bliss,
  ppl,
  singular,
  cddlib,
  lrs,
  nauty,
  ninja,
  ant,
  openjdk,
  mongoc,
  perl,
  perlPackages,
  makeWrapper,
}:

# polymake compiles its own version of sympol and atint because we
# don't have those packages. other missing optional dependencies:
# javaview, libnormaliz, scip, soplex, jreality.

stdenv.mkDerivation (finalAttrs: {
  pname = "polymake";
  version = "4.15";

  src = fetchurl {
    # "The minimal version is a packager friendly version which omits
    # the bundled sources of cdd, lrs, libnormaliz, nauty and jReality."
    url = "https://polymake.org/lib/exe/fetch.php/download/polymake-${finalAttrs.version}-minimal.tar.bz2";
    sha256 = "sha256-MOCo+JATz3qaRO2Q2y9pxJvxgQUGZMfmvbhhxhCxvbk=";
  };

  nativeBuildInputs = [
    makeWrapper
    ninja
    ant
    perl
  ];

  buildInputs = [
    perl
    gmp
    mpfr
    flint
    boost
    bliss
    ppl
    singular
    cddlib
    lrs
    nauty
    openjdk
    mongoc
  ]
  ++ (with perlPackages; [
    JSON
    TermReadLineGnu
    TermReadKey
    XMLSAX
  ]);

  configureFlags = [
    "--with-mongoc=${mongoc}"
  ];

  ninjaFlags = [
    "-C"
    "build/Opt"
  ];

  postInstall = ''
    for i in "$out"/bin/*; do
      wrapProgram "$i" --prefix PERL5LIB : "$PERL5LIB"
    done
  '';

  meta = {
    description = "Software for research in polyhedral geometry";
    homepage = "https://www.polymake.org/doku.php";
    changelog = "https://github.com/polymake/polymake/blob/V${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.linux;
  };
})
