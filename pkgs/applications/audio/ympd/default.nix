{ stdenv, fetchFromGitHub, cmake, llvmPackages, pkgconfig, mpd_clientlib, openssl }:

stdenv.mkDerivation rec {
  name = "ympd-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "ympd";
    rev = "0301b62bb4743a869018269975f746f663ccabe9";
    sha256 = "03w512ik15f0727y3rdzsh8szjg28cn3bgd0zpbkjbibysp2wbzc";
  };

  buildInputs = [ cmake pkgconfig mpd_clientlib openssl ];

  meta = {
    homepage = "http://www.ympd.org";
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
    platforms = stdenv.lib.platforms.unix;
  };
}
