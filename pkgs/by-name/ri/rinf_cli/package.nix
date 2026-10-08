{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rinf_cli";
  version = "8.11.0";

  src = fetchFromGitHub {
    owner = "cunarist";
    repo = "rinf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eYcKisEOkSH8RB+BHCBMgGbu4rswiFLq4+jNo/lRaHc=";
  };
  sourceRoot = "${finalAttrs.src.name}/rust_crate_cli";

  cargoHash = "sha256-POyL32SwjCjOaYKbsYmdhsX8ViRa00aQQaSuoB9+XW8=";

  meta = {
    description = "Framework for creating cross-platform Rust apps leveraging Flutter";
    homepage = "https://rinf.cunarist.com";
    changelog = "https://github.com/cunarist/rinf/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Noah765 ];
    mainProgram = "rinf";
  };
})
