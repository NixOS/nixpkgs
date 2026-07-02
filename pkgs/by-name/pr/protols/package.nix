{
  lib,
  protobuf,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protols";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = finalAttrs.version;
    hash = "sha256-VB7Zs1Zo+hn+M4vhBmOZNod3Q9dbwcMNwRvTIIP+Gk4=";
  };

  cargoHash = "sha256-qfNWZmJYVKDKZ8/JIXtSWYnq4pZXmU7rXQDV117j/a0=";

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
