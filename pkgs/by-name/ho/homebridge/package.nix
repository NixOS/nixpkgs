{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "homebridge";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "homebridge";
    repo = "homebridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Eau8DR2c+2/Nuop2nmkwHPHEUWvzRzm2fTUxuXhgBmM=";
  };

  npmDepsHash = "sha256-Wvyoyq+myUgyGZkK+90H5YSVStL23SyxIJLWFcamQ7w=";

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
