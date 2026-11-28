{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impacket-rs";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nestho";
    repo = "impacket-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bu98N2Egw3/Y0iWQawif8RXHD0ewSI3z/Jf/JHWdj3k=";
  };

  cargoHash = "sha256-Dctpo0iml4zSLn3ZBdCCWTji+LS4CH2E3eFQp7JGrfI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Impacket protocols and Active Directory tools";
    homepage = "https://github.com/nestho/impacket-rs";
    changelog = "https://github.com/nestho/impacket-rs/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "impacket-rs";
  };
})
