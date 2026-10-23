{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S0dm95lqPNgZtueCSZQWxHmYfMIpgbJi+Rs/ClGnrRk=";
  };

  npmDepsHash = "sha256-uUSUt0TjaO8rh3K/Ob7syBDboISTVRRcvgWKD+VVHkU=";

  meta = {
    description = "Lightweight emulator of iOS HomeKit API";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
})
