{ stdenv, fetchurl }:
let
  version = "15.04.6";
in
stdenv.mkDerivation {
  name = "curaengine-${version}";

  src = fetchurl {
    url = "https://github.com/Ultimaker/CuraEngine/archive/${version}.tar.gz";
    sha256 = "1cd4dikzvqyj5g80rqwymvh4nwm76vsf78clb37kj6q0fig3qbjg";
  };

  postPatch = ''
    sed -i 's,--static,,g' Makefile
  '';

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
