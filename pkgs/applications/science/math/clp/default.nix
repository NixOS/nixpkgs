{ lib, stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.17.6";
  pname = "clp";
  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Clp/Clp-${version}.tgz";
    sha256 = "0ap1f0lxppa6pnbc4bg7ih7a96avwaki482nig8w5fr3vg9wvkzr";
  };

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  meta = with lib; {
    license = licenses.epl10;
    homepage = "https://github.com/coin-or/Clp";
    description = "An open-source linear programming solver written in C++";
    platforms = platforms.darwin ++ [ "x86_64-linux" ];
    maintainers = [ maintainers.vbgl ];
  };
}
