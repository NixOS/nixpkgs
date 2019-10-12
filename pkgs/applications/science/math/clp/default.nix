{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.17.3";
  pname = "clp";
  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Clp/Clp-${version}.tgz";
    sha256 = "0ws515f73vq2p4nzyq0fbnm4zp9a7mjg54szdzvkql5dj51gafx1";
  };

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  meta = with stdenv.lib; {
    license = licenses.epl10;
    homepage = "https://github.com/coin-or/Clp";
    description = "An open-source linear programming solver written in C++";
    platforms = platforms.darwin ++ [ "x86_64-linux" ];
    maintainers = [ maintainers.vbgl ];
  };
}
