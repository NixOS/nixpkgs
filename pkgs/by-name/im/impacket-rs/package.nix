{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impacket-rs";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nestho";
    repo = "impacket-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eStw3Pg+Y+q7FfWLC1EEW/tC3B436Ejf9AgR6OQvJhY=";
  };

  cargoHash = "sha256-TCD5LmVPAotGrAzaRjOHXZnL9CVYIkq1xPy7bOsEaCY=";

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
