{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6w2SDnP7P89j3/oLR77D0ubOzDb93krrRJQsDrhPTR4=";
  };

  npmDepsHash = "sha256-m6ZLwDyWEwll7PYRHREThj+SvkfCNgODrpo8DTk6j8w=";

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
