{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mmtui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "SL-RU";
    repo = "mmtui";
    tag = "mmt-v${finalAttrs.version}";
    hash = "sha256-ESnxy3TUWBb0akP471dK6wFQyJQSnjlIevA7ndLAjoE=";
  };

  cargoHash = "sha256-Ck2mQ8PuA4apF6XKDtISmEtNFEHFRRlZwpYCDKCR/rc=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/SL-RU/mmtui/releases/tag/v${finalAttrs.version}";
    description = "TUI disk mount manager for TUI file managers";
    homepage = "https://github.com/SL-RU/mmtui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grimmauld ];
    mainProgram = "mmtui";
    platforms = lib.platforms.linux;
  };
})
