{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.17.5";
  pname = "clp";
  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Clp/Clp-${version}.tgz";
    sha256 = "0y5wg4lfffy5vh8gc20v68pmmv241ndi2jgm9pgvk39b00bzkaa9";
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
