{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diego";
  version = "0.24.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kent-tokyo";
    repo = "diego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RnQezfJ+4d81Sl+b8PvEeRGRddniIHJZ1u/oqdA4okc=";
  };

  cargoHash = "sha256-ODikAKNgZFthhMdPH5Os/SKFY3BGUhYjvVjSm/tx4/A=";

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Active Directory security diagnostics";
    homepage = "https://github.com/kent-tokyo/diego";
    changelog = "https://github.com/kent-tokyo/diego/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "diego";
  };
})
