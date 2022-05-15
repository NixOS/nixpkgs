{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "UHDM";
  version = "2022.05.15";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "18ec4cce8c9414c135dc0e69155f777195dfe328";
    hash = "sha256-ZWeMHHqgpdYlYzhRdTLXCe07dh0Pe8/ylU5TO3cAOmA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    (python3.withPackages (p: with p; [ orderedmultidict ]))
  ];

  doCheck = true;
  checkPhase = "make test";

  postInstall = ''
    mv $out/lib/uhdm/* $out/lib/
    rm -rf $out/lib/uhdm
  '';

  meta = {
    description = "Universal Hardware Data Model";
    homepage = "https://github.com/chipsalliance/UHDM";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
}
