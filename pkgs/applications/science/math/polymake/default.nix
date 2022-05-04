{ lib, stdenv, fetchurl
, perl, gmp, mpfr, flint, boost
, bliss, ppl, singular, cddlib, lrs, nauty
, ninja, ant, openjdk
, perlPackages
, makeWrapper
}:

# polymake compiles its own version of sympol and atint because we
# don't have those packages. other missing optional dependencies:
# javaview, libnormaliz, scip, soplex, jreality.

stdenv.mkDerivation rec {
  pname = "polymake";
  version = "4.6";

  src = fetchurl {
    # "The minimal version is a packager friendly version which omits
    # the bundled sources of cdd, lrs, libnormaliz, nauty and jReality."
    url = "https://polymake.org/lib/exe/fetch.php/download/polymake-${version}-minimal.tar.bz2";
    sha256 = "sha256-QjpE3e8R6uqEV6sV3V2G3beovMbJuxF3b54pWNfc+dA=";
  };

  buildInputs = [
    perl gmp mpfr flint boost
    bliss ppl singular cddlib lrs nauty
    openjdk
  ] ++ (with perlPackages; [
    JSON TermReadLineGnu TermReadKey XMLSAX
  ]);

  nativeBuildInputs = [
    makeWrapper ninja ant perl
  ];

  ninjaFlags = [ "-C" "build/Opt" ];

  postInstall = ''
    for i in "$out"/bin/*; do
      wrapProgram "$i" --prefix PERL5LIB : "$PERL5LIB"
    done
  '';

  meta = with lib; {
    description = "Software for research in polyhedral geometry";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.linux;
    homepage = "https://www.polymake.org/doku.php";
  };
}
