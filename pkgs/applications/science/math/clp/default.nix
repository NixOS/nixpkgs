{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.17.2";
  pname = "clp";
  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Clp/Clp-${version}.tgz";
    sha256 = "1fkmgpn0zaraymi6s3isrrscgjxggcs2yjrx7jfy4hb1jacx71zz";
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
