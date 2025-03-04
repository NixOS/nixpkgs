{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  overrideSDK,
}:
let
  buildNpmPackage' = buildNpmPackage.override {
    stdenv = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
  };
in
buildNpmPackage' rec {
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

  dontNpmBuild = true;
  dontNpmPrune = true;

  postFixup = ''
    # Remove broken symlink
    rm $out/lib/node_modules/eslint/node_modules/eslint-config-eslint
  '';

  meta = {
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
