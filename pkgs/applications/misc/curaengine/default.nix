{ stdenv, fetchgit }:
stdenv.mkDerivation {
    name = "curaengine";

    src = fetchgit {
        url = "https://github.com/Ultimaker/CuraEngine";
        rev = "62667ff2e7479b55d75e3d1dc9136242adf4a6a0";
        sha256 = "0c68xmnq4c49vzg2cyqb375kc72rcnghj21wp3919w8sfwil00vr";
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
    };
}
