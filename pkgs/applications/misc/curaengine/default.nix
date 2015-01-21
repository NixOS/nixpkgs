{ stdenv, fetchurl }:
let
  version = "14.12.1";
in
stdenv.mkDerivation {
  name = "curaengine-${version}";

  src = fetchurl {
    url = "https://github.com/Ultimaker/CuraEngine/archive/${version}.tar.gz";
    sha256 = "1cfns71mjndy2dlmccmjx8ldd0p5v88sqg0jg6ak5c864cvgbjdr";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp build/CuraEngine $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Engine for processing 3D models into 3D printing instructions";
    homepage = https://github.com/Ultimaker/CuraEngine;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
