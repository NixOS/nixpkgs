{
  lib,
  pkgs,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
}:

buildNpmPackage rec {
  pname = "homebridge";
  version = "1.8.5";
  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    rev = "v${version}";
    hash = "sha256-zBzrfn4d6nPuotXIS97cX2H5GD/FSYfALrRv7LDIEis=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-oQcotnMhw5MdlMm7le7nZ1dbJrHdlFZwsIeVAiMGBBw=";

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
