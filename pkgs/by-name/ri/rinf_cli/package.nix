{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rinf_cli";
  version = "8.9.0";

  src = fetchFromGitHub {
    owner = "cunarist";
    repo = "rinf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UHYYpNlhXRYysQlo3EWDUe4Fwp7PMifrQuZcMAGJp6Q=";
  };
  sourceRoot = "${finalAttrs.src.name}/rust_crate_cli";

  cargoHash = "sha256-T1reyeoaGBb+Wyn8WX/u7Kf9B01GwWUcYntb7PlIfCk=";

  meta = {
    description = "Framework for creating cross-platform Rust apps leveraging Flutter";
    homepage = "https://rinf.cunarist.com";
    changelog = "https://github.com/cunarist/rinf/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Noah765 ];
    mainProgram = "rinf";
  };
})
