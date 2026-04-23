{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dts-lsp";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "igor-prusov";
    repo = "dts-lsp";
    tag = finalAttrs.version;
    hash = "sha256-8wMY0o8ceVl5UTsSpXf44gbX1ipSuR50cQTRng+MuNk=";
  };

  cargoHash = "sha256-hZZcu3LaG4kkXJSF0uxHrdPB3YWB3hMv+jrMLMDp2aI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server for Device Tree Source files";
    homepage = "https://github.com/igor-prusov/dts-lsp";
    changelog = "https://github.com/igor-prusov/dts-lsp/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "dts-lsp";
  };
})
