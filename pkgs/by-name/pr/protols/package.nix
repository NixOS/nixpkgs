{
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protols";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = finalAttrs.version;
    hash = "sha256-DdSuEWIo0AbCCV3LPTBC2Ql1NSg2vgnCBNzOgFL8/B0=";
  };

  cargoHash = "sha256-R7OgjUEx2Q0rWTIO1CIXS3ogeC9G/RoxvGQBL1Xh/8k=";

  env.FALLBACK_INCLUDE_PATH = "${protobuf}/include";

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
})
