{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avdl";
  version = "0.1.8+1.12.1";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "avdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NQ0IUC51tKfcREQRQLjdxj8+TKw/I2yRMlNIcG158aM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-8GoS31OxpvtWfT+DcHIa6a6+YlrhmO/YkV7YSd2vrd4=";

  meta = {
    description = "Rust port of avro-tools' IDL tooling";
    homepage = "https://github.com/jonhoo/avdl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "avdl";
  };
})
