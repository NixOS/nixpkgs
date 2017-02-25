{ stdenv, fetchFromGitHub, cmake, llvmPackages, pkgconfig, mpd_clientlib, openssl }:

stdenv.mkDerivation rec {
  name = "ympd-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "hschaeidt";
    repo = "ympd";
    rev = "c48e248d23e037576893265167ab6bdd7553bf93";
    sha256 = "1cj4j6cnz3jl2h1v3hjzrp3006cjj1vvisdrj3ah9q0w4lfs9qs5";
  };

  buildInputs = [ cmake pkgconfig mpd_clientlib openssl ];

  meta = {
    homepage = "http://www.ympd.org";
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
    platforms = stdenv.lib.platforms.unix;
  };
}
