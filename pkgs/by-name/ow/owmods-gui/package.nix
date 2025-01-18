{
  lib,
  libsoup_3,
  dbus,
  glib,
  glib-networking,
  librsvg,
  webkitgtk_4_1,
  pkg-config,
  wrapGAppsHook3,
  makeDesktopItem,
  copyDesktopItems,
  rustPlatform,
  buildNpmPackage,
  fetchFromGitHub,
  mono,
  wrapWithMono ? true,
}:
rustPlatform.buildRustPackage rec {
  pname = "owmods-gui";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "ow-mods";
    repo = "ow-mod-man";
    tag = "gui_v${version}";
    hash = "sha256-rTANG+yHE8YfWYUyELoKgj4El+1ZW6vI9NkgADD40pw=";
  };

  cargoHash = "sha256-rFkh2G7kFuQI7nlZIwaqvt7x9bKLqmWU21YwZu2+wUA=";

  buildFeatures = [
    "tauri/custom-protocol"
  ];

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    libsoup_3
    glib
    librsvg
    glib-networking
    webkitgtk_4_1
  ];

  buildAndTestSubdir = "owmods_gui/backend";

  preFixup = lib.optionalString wrapWithMono "gappsWrapperArgs+=(--prefix PATH : '${mono}/bin')";

  postPatch =
    let
      frontend = buildNpmPackage {
        inherit version;

        env.VITE_VERSION_SUFFIX = "-nix";

        pname = "owmods-gui-ui";
        src = "${src}/owmods_gui/frontend";

        packageJSON = "${src}/owmods_gui/frontend/package.json";
        npmDepsHash = "sha256-h6e+hQzd52G3XtufioEYlBuXNu6I+ZTQcNgJaQdaAck=";

        postBuild = ''
          cp -r ../dist/ $out
        '';
        distPhase = "true";
        dontInstall = true;
        installInPlace = true;
        distDir = "../dist";

        meta = {
          description = "Web frontend for the Outer Wilds Mod Manager";
          homepage = "https://github.com/ow-mods/ow-mod-man/tree/main/owmods_gui/frontend";
          license = lib.licenses.gpl3Plus;
        };
      };
    in
    ''
      substituteInPlace owmods_gui/backend/tauri.conf.json \
        --replace-fail '"frontendDist": "../dist"' '"frontendDist": "${frontend}"'
    '';

  postInstall = ''
    install -DT owmods_gui/backend/icons/128x128@2x.png $out/share/icons/hicolor/256x256@2/apps/outer-wilds-mod-manager.png
    install -DT owmods_gui/backend/icons/128x128.png $out/share/icons/hicolor/128x128/apps/outer-wilds-mod-manager.png
    install -DT owmods_gui/backend/icons/32x32.png $out/share/icons/hicolor/32x32/apps/outer-wilds-mod-manager.png

    mv $out/bin/owmods_gui $out/bin/outer-wilds-mod-manager
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "outer-wilds-mod-manager";
      exec = "outer-wilds-mod-manager %u";
      icon = "outer-wilds-mod-manager";
      desktopName = "Outer Wilds Mod Manager";
      categories = [ "Game" ];
      comment = "Manage Outer Wilds Mods";
      mimeTypes = [ "x-scheme-handler/owmods" ];
    })
  ];

  meta = {
    description = "GUI version of the mod manager for Outer Wilds Mod Loader";
    homepage = "https://github.com/ow-mods/ow-mod-man/tree/main/owmods_gui";
    downloadPage = "https://github.com/ow-mods/ow-mod-man/releases/tag/gui_v${version}";
    changelog = "https://github.com/ow-mods/ow-mod-man/releases/tag/gui_v${version}";
    mainProgram = "outer-wilds-mod-manager";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      bwc9876
      locochoco
      spoonbaker
    ];
  };
}
