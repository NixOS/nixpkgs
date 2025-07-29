{
  lib,
  rustPlatform,
  fetchFromGitHub,
  wrapGAppsHook4,
  pkg-config,
  fuse,
  glib,
  gtk4,
  hicolor-icon-theme,
  libadwaita,
  pango,
  webkitgtk_6_0,
  nix-update-script,
  nixosTests,
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

  # Avoiding optimizations for reproducibility
  prePatch = ''
    substituteInPlace .cargo/config.toml \
      --replace-fail '"-C", "target-cpu=native", ' ""
  '';

  cargoHash = "sha256-rwf9jdr+RDpUcTEG7Xhpph0zuyz6tdFx6hWEZRuxkTY=";

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    fuse
    glib
    gtk4
    hicolor-icon-theme
    libadwaita
    pango
    webkitgtk_6_0
  ];

  # the program expects icons to be installed but the
  # program does not install them itself
  postInstall = ''
    mkdir -p $out/share/icons
    cp -r ${finalAttrs.src}/data/hicolor $out/share/icons
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) oku; };
  };

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
