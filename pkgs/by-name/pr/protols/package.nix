{
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protols";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = finalAttrs.version;
    hash = "sha256-OREJDG0RycYhULTbqx2dXaXlIYexebUFdCiJbBN3cXE=";
  };

  cargoHash = "sha256-uero/p1ATagY6k8t6QCdfPRLeZreVrvshe3dE/M9dkg=";

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
