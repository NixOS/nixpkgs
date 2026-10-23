{
  fetchFromGitHub,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  nix-update-script,
  pkg-config,
  rustPlatform,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "any2nix-gui";
  version = "0.1.4";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "gbr-ufs";
    repo = "any2nix";
    tag = "${finalAttrs.pname}-v${finalAttrs.version}";
    hash = "sha256-nL07U3D3TS6gz1/yRVrk7Zb7hHdDEB4vVBuRHLlA2xo=";
  };
  cargoHash = "sha256-hkk5gnRl+H/RxrbTAouqDqZhv8yttbWXwFD/F01JdIg=";
  buildAndTestSubdir = "any2nix-gui";
  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
  ];
  postInstall = ''
    install -Dm644 any2nix-gui/data/dev.gs-101.any2nix.desktop $out/share/applications/dev.gs-101.any2nix.desktop
    install -Dm644 any2nix-gui/assets/img/any2nix.svg $out/share/icons/hicolor/scalable/apps/dev.gs-101.any2nix.svg
  '';
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Graphical interface for translating from various formats to Nix.";
    homepage = "https://github.com/gbr-ufs/any2nix";
    changelog = "https://github.com/gbr-ufs/any2nix/raw/${finalAttrs.pname}-v${finalAttrs.version}/${finalAttrs.pname}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
    ];
    mainProgram = "any2nix-gui";
    maintainers = with lib.maintainers; [
      gbr-ufs
    ];
  };
})
