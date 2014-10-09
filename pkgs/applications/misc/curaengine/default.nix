{ stdenv, fetchurl }:
let
  version = "14.03";
in
stdenv.mkDerivation {
  name = "curaengine-${version}";

  src = fetchurl {
    url = "https://github.com/Ultimaker/CuraEngine/archive/${version}.tar.gz";
    sha256 = "0f37jk6w3zd9x29c1rydqmfdzybx9nbmwdi3y3nzynq1vq7zmxcc";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp CuraEngine $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Engine for processing 3D models into 3D printing instructions";
    homepage = https://github.com/Ultimaker/CuraEngine;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
