{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.17.0";
  name = "clp-${version}";
  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Clp/Clp-${version}.tgz";
    sha256 = "1p3slyi6vz5b2r7jlp66659kqll5r5hj83y9f0mrla3mh1bxlb79";
  };

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  meta = {
    license = stdenv.lib.licenses.epl10;
    homepage = https://projects.coin-or.org/Clp;
    description = "An open-source linear programming solver written in C++";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
