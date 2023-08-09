{ lib
, stdenv
, fetchurl
, gmp
, mpfr
, flint
, boost
, bliss
, ppl
, singular
, cddlib
, lrs
, nauty
, ninja
, ant
, openjdk
, perl536Packages
, makeWrapper
}:
let
  # log says: polymake does not work with perl 5.37 or newer;
  perlPackages = perl536Packages;
  inherit (perlPackages) perl;
in
# polymake compiles its own version of sympol and atint because we
# don't have those packages. other missing optional dependencies:
# javaview, libnormaliz, scip, soplex, jreality.

stdenv.mkDerivation rec {
  pname = "polymake";
  version = "4.10";

  src = fetchurl {
    # "The minimal version is a packager friendly version which omits
    # the bundled sources of cdd, lrs, libnormaliz, nauty and jReality."
    url = "https://polymake.org/lib/exe/fetch.php/download/polymake-${version}-minimal.tar.bz2";
    sha256 = "sha256-YDiyZtbUC76ZVe3oRtzPRBfkEU+qh+d1ZWFhzUyi+Pg=";
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
  ] ++ (with perlPackages; [
    JSON
    TermReadLineGnu
    TermReadKey
    XMLSAX
  ]);

  ninjaFlags = [ "-C" "build/Opt" ];

  postInstall = ''
    for i in "$out"/bin/*; do
      wrapProgram "$i" --prefix PERL5LIB : "$PERL5LIB"
    done
  '';

  meta = with lib; {
    description = "Software for research in polyhedral geometry";
    homepage = "https://www.polymake.org/doku.php";
    changelog = "https://github.com/polymake/polymake/blob/V${version}/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.linux;
  };
}
