{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cargo-pretty";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "romancitodev";
    repo = "cargo-pretty";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6Nv/Yo2Z10YbEnqYGWwN3AxnJfv1aXPvn/JAcZ87Y4k=";
  };

  cargoHash = "sha256-d9u8pyxzx+SNvQiCobTMul+KSuXMkGc//GAtBKIWd6k=";

  meta = {
    description = "Cargo build wrapper with a live, animated status view";
    mainProgram = "cargo-pretty";
    homepage = "https://github.com/romancitodev/cargo-pretty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tobinio ];
  };
})
