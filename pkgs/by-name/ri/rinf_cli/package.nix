{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rinf_cli";
  version = "8.10.1";

  src = fetchFromGitHub {
    owner = "cunarist";
    repo = "rinf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4nTpAf+nkf1Y5VmJDZ8RwI+8W/szoDbcsZW3oHI/O/0=";
  };
  sourceRoot = "${finalAttrs.src.name}/rust_crate_cli";

  cargoHash = "sha256-B7kbwGIr1p1X9xtNOOERVtVKi0kAncvIEQh4YSgqNTc=";

  meta = {
    description = "Framework for creating cross-platform Rust apps leveraging Flutter";
    homepage = "https://rinf.cunarist.com";
    changelog = "https://github.com/cunarist/rinf/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Noah765 ];
    mainProgram = "rinf";
  };
})
