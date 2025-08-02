{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "lcm";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "lcm-proj";
    repo = "lcm";
    rev = "v${version}";
    hash = "sha256-043AJzalfx+qcCoxQgPU4T/DcUH0pXOE4v1aJaW3aXs=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    glib
  ];

  meta = {
    description = "Lightweight Communications and Marshalling (LCM)";
    homepage = "https://github.com/lcm-proj/lcm";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ kjeremy ];
    platforms = lib.platforms.unix;
  };
}
