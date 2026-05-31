{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "burn-central-cli";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "tracel-ai";
    repo = "burn-central-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wXLfmCV6aElnYnhOCScr/3+4I6oOfNPrZ8+0t4TPDOA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildAndTestSubdir = "crates/burn-central-cli";

  cargoHash = "sha256-MeDIYFXkyJdxierq9iVIAvEIc8JU13szrbSTfKyUkJk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    # Pulled in by flate2
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for interacting with Burn Central";
    longDescription = ''
      The Burn Central CLI (burn) is the command-line tool for interacting
      with Burn Central, the centralized platform for experiment tracking,
      model sharing, and deployment for Burn users.
    '';
    homepage = "https://github.com/tracel-ai/burn-central-cli";
    changelog = "https://github.com/tracel-ai/burn-central-cli/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ kilyanni ];
    mainProgram = "burn";
  };
})
