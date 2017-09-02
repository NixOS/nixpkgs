{ stdenv, fetchFromGitHub, cmake, llvmPackages, pkgconfig, mpd_clientlib, openssl }:

stdenv.mkDerivation rec {
  name = "ympd-${version}";
  version = "1.4.0-rc1";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "maympd";
    rev = "25e428289a31433482b1e7cafbf572496943d193";
    sha256 = "0sg8r4fpb4gja8adz6043h1qsl7z626llzqysr87q8rrl9ij1j8g";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ mpd_clientlib openssl ];

  meta = with stdenv.lib; {
    homepage = https://www.ympd.org;
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.unix;
  };
}
