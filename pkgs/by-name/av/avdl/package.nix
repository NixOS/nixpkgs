{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avdl";
  version = "0.1.7+1.12.1";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "avdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hqZt+3Bewr4+0Uh4u0pXErcLzlmL1AY4Gq41WNnQNN8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-B0TAJHTrpDT6C57FAc9wqgyA3kkI77P2RzrInQluR2M=";

  meta = {
    description = "Rust port of avro-tools' IDL tooling";
    homepage = "https://github.com/jonhoo/avdl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "avdl";
  };
})
