{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rinf_cli";
  version = "8.8.1";

  src = fetchFromGitHub {
    owner = "cunarist";
    repo = "rinf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nqzc3GXOXl+0zBOUQN58ib9HvVRMKymHckw9KGoKKyU=";
  };
  sourceRoot = "${finalAttrs.src.name}/rust_crate_cli";

  cargoHash = "sha256-R55WVlVR5gjg4U4Icp379dXUp9tJAR0eTZy6glzA7nk=";

  meta = {
    description = "Framework for creating cross-platform Rust apps leveraging Flutter";
    homepage = "https://rinf.cunarist.com";
    changelog = "https://github.com/cunarist/rinf/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Noah765 ];
    mainProgram = "rinf";
  };
})
