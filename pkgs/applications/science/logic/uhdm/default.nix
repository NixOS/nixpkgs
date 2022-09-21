{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "UHDM";
  version = "0.9.1.37";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mhbgjdbnjZShfwgdZEZshiNkRMPLT5oGcAnrvfrO7DM=";
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
