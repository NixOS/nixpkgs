{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, yarnConfigHook
, yarnBuildHook
, nodejs
, npmHooks
, olm
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  offlineCacheHash = {
    x86_64-linux = "sha256-mZCnvX6hzkdi/zjPiefcmbyC2kGemjS4w7WTVkyq8W0=";
    aarch64-linux = "sha256-mZCnvX6hzkdi/zjPiefcmbyC2kGemjS4w7WTVkyq8W0=";
    x86_64-darwin = "sha256-G4doEnZORJqcl3bWaKZPuQmBeXNXud06nLO12Afr9kM=";
    aarch64-darwin = "sha256-G4doEnZORJqcl3bWaKZPuQmBeXNXud06nLO12Afr9kM=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "element-call";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "element-call";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GTHM27i716RZk+kDELMg/lYy355/SZoQLXGPQ90M4xg=";
  };

  patches = [ ./name.patch ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = offlineCacheHash;
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    npmHooks.npmInstallHook
  ];
  # From some reason causes the build to fail due to dependencies not available
  # offline
  dontNpmPrune = true;

  meta = with lib; {
    homepage = "https://github.com/element-hq/element-call";
    description = "Group calls powered by Matrix";
    license = licenses.asl20;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "element-call";
    inherit (olm.meta) knownVulnerabilities;
  };
})
