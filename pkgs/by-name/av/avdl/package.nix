{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avdl";
  version = "0.1.6+1.12.1";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "avdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ReTsyIZ+w7wWhREmkZT6tNsEFkpF2KVJsFAhCfL5CZQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-WiAPUD5AAsYSxJ5tn8/6ZjMf3hEOtTXzOMIVXd6f9l0=";

  meta = {
    description = "Rust port of avro-tools' IDL tooling";
    homepage = "https://github.com/jonhoo/avdl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "avdl";
  };
})
