{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ofj1QzDIeu4hjuonOlAHqrFDeU81gCEbMQaymyae8Pk=";
  };

  npmDepsHash = "sha256-inWQray0Vhl0xEil54C0HC92+D59oLbWYMl+7lpUsjI=";

  # Homebridge's clean phase attempts to install rimraf directly, which fails in nix builds
  # rimraf is already in the declared dependencies, so we just don't need to do it.
  # This will replace "npm install rimraf && rimraf lib/" with "rimraf lib/".
  preBuild = ''
    cat package.json | ${jq}/bin/jq '.scripts.clean = "rimraf lib/"' > package.json.tmp
    mv package.json.tmp package.json
  '';

  meta = {
    description = "Homebridge";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
})
