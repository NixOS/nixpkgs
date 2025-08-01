{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "15.04.6";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "sha256-8V21TRSqCN+hkTlz51d5A5oK5JOwEtx+ROt8cfJBL/0=";
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
    mainProgram = "CuraEngine";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
  };
}
