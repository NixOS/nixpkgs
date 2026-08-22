{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  swift,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "source-meta-json-schema";
  version = "16.8.0";

  src = fetchFromGitHub {
    owner = "sourcemeta";
    repo = "jsonschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TMNYLwMfPZnWUfCHJIgReuZMjbECrVxXEJGp0XNqa9M=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ swift ];

  meta = {
    homepage = "https://github.com/sourcemeta/jsonschema";
    description = "CLI for working with JSON Schema. Covers formatting, linting, testing, bundling, and more for both local development and CI/CD pipelines";
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
