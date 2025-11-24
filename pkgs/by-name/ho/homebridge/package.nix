{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E21HowCRD78MZW3+um6vN5/NLncF/bt9v/Tw+RYe5xM=";
  };

  npmDepsHash = "sha256-Da64zHwvX0W1viNhy4afr60onlWqbizaVox9Un6c65Y=";

  # Homebridge's clean phase attempts to install rimraf directly, which fails in nix builds
  # rimraf is already in the declared dependencies, so we just don't need to do it.
  # This will replace "npm install rimraf && rimraf lib/" with "rimraf lib/".
  preBuild = ''
    cat package.json | ${jq}/bin/jq '.scripts.clean = "rimraf lib/"' > package.json.tmp
    mv package.json.tmp package.json
  '';

  meta = {
    description = "Lightweight emulator of iOS HomeKit API";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
})
