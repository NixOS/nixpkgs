{
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protols";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = finalAttrs.version;
    hash = "sha256-GgCJPL18xcMSipaM4YwyuaR1sEadu1Zwyt5qWJXdS3c=";
  };

  cargoHash = "sha256-1HZlNW4wLMXpFp+Z3HAEC0w3Ro+Rh/EdPxoBuFeyDjE=";

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
