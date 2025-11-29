{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "eslint";
  version = "9.20.0";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    tag = "v${version}";
    hash = "sha256-ahERh5Io2J/Uz9fgY875ldPtzjiasqxZ0ppINwYNoB4=";
  };

  # NOTE: Generating lock-file
  # arch = [ x64 arm64 ]
  # platform = [ darwin linux]
  # npm install --package-lock-only --arch=<arch> --platform=<os>
  # darwin seems to generate a cross platform compatible lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-F3EUANBvniczR7QxNfo1LlksYPxXt16uqJDFzN6u64Y=";
  npmInstallFlags = [ "--omit=dev" ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  meta = {
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mdaniels5757
      onny
    ];
  };
}
