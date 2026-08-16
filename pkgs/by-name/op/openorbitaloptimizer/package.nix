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

stdenv.mkDerivation (finalAttrs: {
  pname = "openorbitaloptimizer";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "susilehtola";
    repo = "openorbitaloptimizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bX+pJXZsAdPuWjJi/BynvQt8JnWQAd8NcXTWSH7bi40=";
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
    license = lib.licenses.mpl20;
    homepage = "https://github.com/susilehtola/OpenOrbitalOptimizer";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
