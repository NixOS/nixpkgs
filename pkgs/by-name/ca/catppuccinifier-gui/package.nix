{
  lib,
  gtk3,
  glib,
  dbus,
  nodejs,
  cairo,
  cargo-tauri,
  webkitgtk_4_1,
  wrapGAppsHook3,
  gdk-pixbuf,
  pkg-config,
  rustPlatform,
  fetchYarnDeps,
  yarnConfigHook,
  fetchFromGitHub,
  desktop-file-utils,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "catppuccinifier-gui";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "lighttigerXIV";
    repo = "catppuccinifier";
    tag = "${finalAttrs.version}";
    hash = "sha256-e8sLYp+0YhC/vAn4vag9UUaw3VYDRERGnLD1RuW1TXE=";
  };

  sourceRoot = finalAttrs.src.name + "/src/catppuccinifier-gui";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-BUXqPY3jNn4YB1avtCp6MFyN1KIYqT0b1H9drOmikj0=";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/src/catppuccinifier-gui/yarn.lock";
    hash = "sha256-UfQZf2raMrgPhUQVTAW+mA/nP1XjLKx0WBbYtdeD9kY=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    nodejs
    yarnConfigHook
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    webkitgtk_4_1
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
  ];

  postInstall = ''
    desktop-file-edit "$out/share/applications/catppuccinifier-gui.desktop" \
      --set-key "Categories" --set-value "Graphics" \
      --set-key "Comment" --set-value "Apply catppuccin flavors to your wallpapers"
  '';

  meta = {
    description = "Apply catppuccin flavors to your wallpapers";
    homepage = "https://github.com/lighttigerXIV/catppuccinifier";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    platforms = lib.platforms.linux;
    mainProgram = "catppuccinifier-gui";
  };
})
