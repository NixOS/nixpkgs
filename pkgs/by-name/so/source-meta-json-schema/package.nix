{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:
let
<<<<<<< HEAD
  version = "12.9.3";
=======
  version = "12.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
stdenv.mkDerivation (finalAttrs: {
  pname = "source-meta-json-schema";
  inherit version;

  src = fetchFromGitHub {
    owner = "sourcemeta";
    repo = "jsonschema";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QfjCoYl+v/1El0IW11ZkKCLRN52GDFjpCGyclUyB9GM=";
=======
    hash = "sha256-j8FQLOJSdVzNsO4piQK1B90p4cCbAQQgceNH5Us6/bE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
