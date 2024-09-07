{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  overrideSDK,
}:
let
  buildNpmPackage' = buildNpmPackage.override {
    stdenv = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
  };
in
buildNpmPackage' rec {
  pname = "eslint";
  version = "9.9.1";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    rev = "refs/tags/v${version}";
    hash = "sha256-n07a50bigglwr3ItZqbyQxu0mPZawTSVunwIe8goJBQ=";
  };

  # NOTE: Generating lock-file
  # arch = [ x64 arm64 ]
  # platform = [ darwin linux]
  # npm install --package-lock-only --arch=<arch> --platform=<os>
  # darwin seems to generate a cross platform compatible lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-sqQ7YeCMMK/9/XOX6QHZjX+2U+dYHkKiAzsLI0ehpAE=";

  dontNpmBuild = true;
  dontNpmPrune = true;

  meta = {
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
