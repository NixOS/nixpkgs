{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.16.11";
  name = "clp-${version}";
  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Clp/Clp-${version}.tgz";
    sha256 = "0fazlqpp845186nmixa9f1xfxqqkdr1xj4va7q29m8594ca4a9dm";
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
