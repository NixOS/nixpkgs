{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "avdl";
  version = "0.1.5+1.12.1";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "avdl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/YGDtezPMMdogk8eGoHgqt8B0t6SNA3TVqroLOOANxs=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-QPC58tt7e8O/KJyE3c5mdLMyEt37hKG9lEDBs47prAQ=";

  meta = {
    description = "Rust port of avro-tools' IDL tooling";
    homepage = "https://github.com/jonhoo/avdl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ck3d ];
    mainProgram = "avdl";
  };
})
