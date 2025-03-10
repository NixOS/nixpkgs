{
  lib,
  pkgs,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "homebridge";
  version = "1.9.0";
  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    rev = "v${version}";
    hash = "sha256-Ofj1QzDIeu4hjuonOlAHqrFDeU81gCEbMQaymyae8Pk=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-inWQray0Vhl0xEil54C0HC92+D59oLbWYMl+7lpUsjI=";

  # Homebridge's clean phase attempts to install rimraf directly, which fails in nix builds
  # rimraf is already in the declared dependencies, so we just don't need to do it.
  # This will replace "npm install rimraf && rimraf lib/" with "rimraf lib/".
  buildPhase = ''
    cat package.json | ${pkgs.jq}/bin/jq '.scripts.clean = "rimraf lib/"' > package.json.tmp
    mv package.json.tmp package.json
    npm run build
  '';

  meta = {
    description = "Homebridge";
    homepage = "https://github.com/homebridge/homebridge";
    license = lib.licenses.asl20;
    mainProgram = "homebridge";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
}
