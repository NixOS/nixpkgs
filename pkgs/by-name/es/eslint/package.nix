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
  version = "9.10.0";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    rev = "refs/tags/v${version}";
    hash = "sha256-R5DO4xN3PkwGAIfyMkohs9SvFiLjWf1ddOwkY6wbsjA=";
  };

  # NOTE: Generating lock-file
  # arch = [ x64 arm64 ]
  # platform = [ darwin linux]
  # npm install --package-lock-only --arch=<arch> --platform=<os>
  # darwin seems to generate a cross platform compatible lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-Nrcld0ONfjdSh/ItdbDMp6dXVFKoj83aaoGXDgoNE60=";

  dontNpmBuild = true;
  dontNpmPrune = true;

  meta = {
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
