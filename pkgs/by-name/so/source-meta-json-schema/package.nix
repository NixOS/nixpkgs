{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
let
  version = "12.0.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "source-meta-json-schema";
  inherit version;

  src = fetchFromGitHub {
    owner = "sourcemeta";
    repo = "jsonschema";
    rev = "v${version}";
    hash = "sha256-fhY/DNuQWzVWQC/Ur0Ksp5eW3S7flV2jEaVQiva160Q=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/sourcemeta/jsonschema";
    description = "CLI for working with JSON Schema. Covers formatting, linting, testing, bundling, and more for both local development and CI/CD pipelines ";
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
