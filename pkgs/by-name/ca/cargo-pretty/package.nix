{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-pretty";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "romancitodev";
    repo = "cargo-pretty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Nv/Yo2Z10YbEnqYGWwN3AxnJfv1aXPvn/JAcZ87Y4k=";
  };

  cargoHash = "sha256-d9u8pyxzx+SNvQiCobTMul+KSuXMkGc//GAtBKIWd6k=";

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo build wrapper with a live, animated status view";
    homepage = "https://crates.io/crates/cargo-pretty-build";
    downloadPage = "https://github.com/romancitodev/cargo-pretty/releases";
    changelog = "https://github.com/romancitodev/cargo-pretty/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "cargo-pretty";
  };
})
