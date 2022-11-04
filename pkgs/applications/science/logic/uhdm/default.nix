{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
}:

stdenv.mkDerivation rec {
  pname = "UHDM";
  version = "0.9.1.40";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CliKU2WM8B9012aDcS/mTyIf+JcsVsc4uRRi9+FRWbM=";
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

  prePatch = ''
    substituteInPlace CMakeLists.txt --replace \
    'capnp compile' \
    'capnp compile --src-prefix=''${GENDIR}/..'
  '';

  meta = {
    description = "Universal Hardware Data Model";
    homepage = "https://github.com/chipsalliance/UHDM";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
}
