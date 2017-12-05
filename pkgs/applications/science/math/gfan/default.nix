{stdenv, fetchurl, gmp, mpir, cddlib}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "gfan";
  version = "0.5";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://home.math.au.dk/jensen/software/gfan/gfan${version}.tar.gz";
    sha256 = "0adk9pia683wf6kn6h1i02b3801jz8zn67yf39pl57md7bqbrsma";
  };
  preBuild = ''
    sed -e 's@static int i;@//&@' -i app_minkowski.cpp
  '';
  makeFlags = ''PREFIX=$(out)'';
  buildInputs = [gmp mpir cddlib];
  meta = {
    inherit version;
    description = ''A software package for computing Gröbner fans and tropical varieties'';
    license = stdenv.lib.licenses.gpl2 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://home.math.au.dk/jensen/software/gfan/gfan.html;
  };
}
