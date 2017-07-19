{ stdenv, fetchFromGitHub, cmake, llvmPackages, pkgconfig, mpd_clientlib, openssl }:

stdenv.mkDerivation rec {
  name = "ympd-${version}";
  version = "1.4.0-rc1";

  src = fetchFromGitHub {
    owner = "mayflower";
    repo = "maympd";
    rev = "772f5af4c4a79cf2187b83a29b684c619507876d";
    sha256 = "1ah94xf9pxwmrzbhb069qk6sy3v9qm6arg08mj6awicvych2k6c4";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ mpd_clientlib openssl ];

  meta = {
    homepage = "http://www.ympd.org";
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
    platforms = stdenv.lib.platforms.unix;
  };
}
