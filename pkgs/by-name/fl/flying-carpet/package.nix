{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flying-carpet";
  version = "9.0.9";

  src = fetchFromGitHub {
    owner = "spieglt";
    repo = "FlyingCarpet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XwhK0/eK8KxVf4aZUY2qgc6IMPnixxdwwrm3dl5Sfmk=";
  };

  cargoHash = "sha256-BtL6tAKIaj7wtJ9VTRbR3Kx8mGi56h9oBG63suCl1OA=";

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pkg-config
    wrapGAppsHook4
    copyDesktopItems
  ];

  buildInputs = [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  checkFlags = [
    "--skip"
    "network"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "FlyingCarpet";
      desktopName = "FlyingCarpet";
      exec = "FlyingCarpet";
      icon = "FlyingCarpet";
      categories = [ "Development" ];
    })
  ];

  postInstall = ''
    install -Dm644 "Flying Carpet/src-tauri/icons/32x32.png" "$out/share/icons/hicolor/32x32/apps/FlyingCarpet.png"
    install -Dm644 "Flying Carpet/src-tauri/icons/128x128.png" "$out/share/icons/hicolor/128x128/apps/FlyingCarpet.png"
    install -Dm644 "Flying Carpet/src-tauri/icons/128x128@2x.png" "$out/share/icons/hicolor/256x256@2/apps/FlyingCarpet.png"
  '';

  preFixup = ''
    # https://github.com/tauri-apps/tauri/issues/9304
    gappsWrapperArgs+=(--set WEBKIT_DISABLE_DMABUF_RENDERER 1)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Send and receive files between Android, iOS, Linux, macOS, and Windows over ad hoc WiFi";
    homepage = "https://github.com/spieglt/FlyingCarpet";
    changelog = "https://github.com/spieglt/FlyingCarpet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux; # No darwin: https://github.com/spieglt/FlyingCarpet/issues/117
    mainProgram = "FlyingCarpet";
  };
})
