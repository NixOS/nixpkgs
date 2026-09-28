{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diego";
  version = "0.23.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kent-tokyo";
    repo = "diego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ufuDdnjM2Hnhpqu1D3/qXfr5Mjur3tdi+e14Yn88VCo=";
  };

  cargoHash = "sha256-GXyQZaj1CGAJutOup36I39xYKMW7VWkMN5q7e2fPsWQ=";

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
