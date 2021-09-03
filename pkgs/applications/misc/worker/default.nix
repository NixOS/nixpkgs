{ lib, stdenv, libX11, fetchurl }:

stdenv.mkDerivation rec {
  pname = "worker";
  version = "4.8.1";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-Cf4vx1f4GgjlhNtGUuXf8174v8PGJapm5L30XUdqbro=";
  };

  buildInputs = [ libX11 ];

  meta = with lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = "http://www.boomerangsworld.de/cms/worker/index.html";
    license =  licenses.gpl2;
    maintainers = [];
  };
}
