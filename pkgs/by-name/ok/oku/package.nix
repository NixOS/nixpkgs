{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fuse,
  libadwaita,
  webkitgtk_6_0,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oku";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "okubrowser";
    repo = "oku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-utbey8DFXUWU6u2H2unNjCHE3/bwhPdrxAOApC+unGA=";
  };

  cargoHash = "sha256-rwf9jdr+RDpUcTEG7Xhpph0zuyz6tdFx6hWEZRuxkTY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fuse
    libadwaita
    webkitgtk_6_0
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Browser for the Oku Network and Peer-to-peer sites";
    homepage = "https://github.com/okubrowser/oku";
    changelog = "https://github.com/OkuBrowser/oku/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "oku";
    platforms = lib.platforms.linux;
  };
})
