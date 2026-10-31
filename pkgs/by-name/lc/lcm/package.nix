{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lcm";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "lcm-proj";
    repo = "lcm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2IWIVq2o6R4pU48VXbizYpmZXsq1r5siATDE4j6WiZU=";
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
    # last successful hydra build on darwin was in 2023
    broken = stdenv.hostPlatform.isDarwin;
    description = "Lightweight Communications and Marshalling (LCM)";
    homepage = "https://github.com/lcm-proj/lcm";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ kjeremy ];
    platforms = lib.platforms.unix;
  };
})
