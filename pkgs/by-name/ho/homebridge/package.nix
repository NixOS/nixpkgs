{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vj868PCGTuigDuxybVsgjD82ehEXQmq9tJO9ZN7FMho=";
  };

  npmDepsHash = "sha256-OEuBTBgcmFzMaH8iEWKogg4O7HXUJlWaT6iAs9n6WcQ=";

  meta = {
    description = "Lightweight emulator of iOS HomeKit API";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
})
