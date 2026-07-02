{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avdl";
  version = "0.1.9+1.12.1";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "avdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HfcDSv3RzmoFbwt7iAP/UXdeJupfng8oeaeerUwW1Ik=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-5ftBXywOUQKzIwjaQVHtxO/6A1bb1jGZAxYYY7GttCg=";

  meta = {
    description = "Rust port of avro-tools' IDL tooling";
    homepage = "https://github.com/jonhoo/avdl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "avdl";
  };
})
