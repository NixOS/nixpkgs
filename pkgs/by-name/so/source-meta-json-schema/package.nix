{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "source-meta-json-schema";
  version = "14.7.1";

  src = fetchFromGitHub {
    owner = "sourcemeta";
    repo = "jsonschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zQ9GyJBaSzDL7i/PurOW4yJR59pX/0CLZ2DgDJmA6+s=";
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
