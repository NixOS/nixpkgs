{
  fetchFromGitHub,
  lib,
  perl,
  pkg-config,
  openssl,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "screenly-cli";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "screenly";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-6whyTCfmBx+PS40ML8VNR5WvIfnUCMxos7KCCbtHXAo=";
  };

  cargoHash = "sha256-LG6/+/Ibw7mh854ue6L74DLK4WocmDWqK8FvsEascYw=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for managing digital signs and screens at scale";
    homepage = "https://github.com/Screenly/cli";
    changelog = "https://github.com/Screenly/cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "screenly";
    maintainers = with lib.maintainers; [
      vpetersson
    ];
  };
}
