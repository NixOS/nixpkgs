{
  lib,
  rustPlatform,
  fetchFromGitHub,
  dbus,
  openssl,
  gtk4,
  gtk4-layer-shell,
  mimalloc,
  glib,
  pkg-config,
  wrapGAppsHook4,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dynisland";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "cr3eperall";
    repo = "dynisland";
    tag = finalAttrs.version;
    hash = "sha256-gO6QniPcv/250CD/cjEJPKijb4cg5R1mUvdrOqamEzk=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cvGsRFaqeMdp2cxgfZZcB2r67Si2K6En4or9HVG4WwA=";

  buildFeatures = [ "completions" ];

  buildInputs = [
    dbus
    openssl
    gtk4
    gtk4-layer-shell
    mimalloc
  ];

  nativeBuildInputs = [
    glib
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    pkg-config
    wrapGAppsHook4
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd dynisland \
      --bash ./target/dynisland.bash \
      --fish ./target/dynisland.fish \
      --zsh ./target/_dynisland
  '';

  meta = {
    description = "Dynamic and extensible GTK4 layer-shell, written in Rust";
    homepage = "https://github.com/cr3eperall/dynisland";
    changelog = "https://github.com/cr3eperall/dynisland/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "dynisland";
    platforms = lib.platforms.linux;
  };
})
