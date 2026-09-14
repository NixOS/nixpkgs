{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "source-meta-json-schema";
  version = "16.10.0";

  src = fetchFromGitHub {
    owner = "sourcemeta";
    repo = "jsonschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-abuZOWO/Dlbx2axIONeVYfy7OyB+GGzjDy7S5AVcZK8=";
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
