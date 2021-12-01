{ lib, stdenv, fetchurl }:
let
  version = "15.04.6";
in
stdenv.mkDerivation {
  pname = "curaengine";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Ultimaker/CuraEngine/archive/${version}.tar.gz";
    sha256 = "1cd4dikzvqyj5g80rqwymvh4nwm76vsf78clb37kj6q0fig3qbjg";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "--static" ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/CuraEngine $out/bin/
  '';

  meta = with lib; {
    description = "Engine for processing 3D models into 3D printing instructions";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3;
    platforms = platforms.linux;
  };
}
