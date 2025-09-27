{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  armadillo,
  libxc,
  integratorxx,
  nlohmann_json,
}:

stdenv.mkDerivation rec {
  pname = "openorbitaloptimizer";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "susilehtola";
    repo = "openorbitaloptimizer";
    tag = "v${version}";
    hash = "sha256-naZwe56c1wsng4L/Q1waPiACeEiEAMhvzr5XMwC1uoY=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    armadillo
    libxc
  ];

  checkInputs = [
    integratorxx
    nlohmann_json
  ];
  doCheck = true;

  meta = {
    description = "Common orbital optimisation algorithms for quantum chemistry";
    license = [ lib.licenses.mpl20 ];
    homepage = "https://github.com/susilehtola/OpenOrbitalOptimizer";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
