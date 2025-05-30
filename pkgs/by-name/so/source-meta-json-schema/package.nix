{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
let
  version = "9.3.1";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "source-meta-json-schema";
  inherit version;

  src = fetchFromGitHub {
    owner = "sourcemeta";
    repo = "jsonschema";
    rev = "v${version}";
    hash = "sha256-uqx2GBG4sTmFWexTr8fCP9r/o37d3vTD93giB/OEmac=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/sourcemeta/jsonschema";
    description = "The CLI for working with JSON Schema. Covers formatting, linting, testing, bundling, and more for both local development and CI/CD pipelines ";
    changelog = "https://github.com/sourcemeta/jsonschema/releases";
    license = with lib.licenses; [
      agpl3Plus
    ];
    maintainers = with lib.maintainers; [
      amerino
    ];
    platforms = lib.platforms.all;
  };
})
