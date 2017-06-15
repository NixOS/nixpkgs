{ stdenv, fetchFromGitHub, cmake, llvmPackages, pkgconfig, mpd_clientlib, openssl }:

stdenv.mkDerivation rec {
  name = "ympd-${version}";
  version = "1.4.0-rc1";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "maympd";
    rev = "v${version}";
    sha256 = "0qp18fvczjlj2dkgrmrw0lb7s5791jn40mww7s1n69zfv46krn5x";
  };

  buildInputs = [ cmake pkgconfig mpd_clientlib openssl ];

  meta = {
    homepage = "http://www.ympd.org";
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
    platforms = stdenv.lib.platforms.unix;
  };
}
