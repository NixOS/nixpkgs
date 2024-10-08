{
  dbus,
  openssl,
  gtk3,
  webkitgtk,
  pkg-config,
  wrapGAppsHook3,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  lib,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,
  alsa-lib,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "lrcget";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "tranxuanthang";
    repo = "lrcget";
    rev = "${version}";
    hash = "sha256-OrmSaRKhGCl5sTirzICx8PBsQm23pYUBBtb07+P1ZbY=";
  };

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-V9+/sfCxeZJ39nOuMBv2YlkzewoS+N3kFyBGdIqkw/A=";

  frontend = buildNpmPackage {
    inherit version src;
    pname = "lrcget-ui";
    # FIXME: This is a workaround, because we have a git dependency node_modules/lrc-kit contains install scripts
    # but has no lockfile, which is something that will probably break.
    forceGitDeps = true;
    distPhase = "true";
    dontInstall = true;
    # To fix `npm ERR! Your cache folder contains root-owned files`
    makeCacheWritable = true;

    npmDepsHash = "sha256-qQ5UMO3UuD6IvUveTRF35qTlGq5PMbxp1Q4UroDqVtk=";

    postBuild = ''
      cp -r dist/ $out
    '';
  };

  # copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    cp -r $frontend ./frontend

    substituteInPlace tauri.conf.json --replace-fail '"distDir": "../dist"' '"distDir": "./frontend"'
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    copyDesktopItems
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      dbus
      openssl
      gtk3
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      webkitgtk
      alsa-lib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreAudio
      darwin.apple_sdk.frameworks.WebKit
    ];

  # Disable checkPhase, since the project doesn't contain tests
  doCheck = false;

  postInstall = ''
    install -DT icons/128x128@2x.png $out/share/icons/hicolor/128x128@2/apps/lrcget.png
    install -DT icons/128x128.png $out/share/icons/hicolor/128x128/apps/lrcget.png
    install -DT icons/32x32.png $out/share/icons/hicolor/32x32/apps/lrcget.png
  '';

  # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
  postFixup = ''
    wrapProgram "$out/bin/lrcget" \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "LRCGET";
      exec = "lrcget";
      icon = "lrcget";
      desktopName = "LRCGET";
      comment = meta.description;
    })
  ];

  meta = {
    description = "Utility for mass-downloading LRC synced lyrics for your offline music library";
    homepage = "https://github.com/tranxuanthang/lrcget";
    changelog = "https://github.com/tranxuanthang/lrcget/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anas
      Scrumplex
    ];
    mainProgram = "lrcget";
    platforms = with lib.platforms; unix ++ windows;
  };
}
