{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri_1,
  cinny,
  desktop-file-utils,
  wrapGAppsHook3,
  makeBinaryWrapper,
  pkg-config,
  openssl,
  dbus,
  glib,
  glib-networking,
  libayatana-appindicator,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage rec {
  pname = "cinny-desktop";
  # We have to be using the same version as cinny-web or this isn't going to work.
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny-desktop";
    rev = "refs/tags/v${version}";
    hash = "sha256-yNGzgkZXz/VroGGnZFqo5n2v3cE6/tvpQv5U4p27row=";
  };

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-0EIKozFwy7XihFRpjLZ3Am7h1wOU7ZGcHSoTnFnYzTU=";

  postPatch =
    let
      cinny' =
        assert lib.assertMsg (
          cinny.version == version
        ) "cinny.version (${cinny.version}) != cinny-desktop.version (${version})";
        cinny.override {
          conf = {
            hashRouter.enabled = true;
          };
        };
    in
    ''
      substituteInPlace tauri.conf.json \
        --replace-warn '"distDir": "../cinny/dist",' '"distDir": "${cinny'}",'
      substituteInPlace tauri.conf.json \
        --replace-warn '"cd cinny && npm run build"' '""'
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/bin"
      ln -sf "$out/Applications/Cinny.app/Contents/MacOS/Cinny" "$out/bin/cinny"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      desktop-file-edit \
        --set-comment "Yet another matrix client for desktop" \
        --set-key="Categories" --set-value="Network;InstantMessaging;" \
        $out/share/applications/cinny.desktop
    '';
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/cinny" \
      --inherit-argv0 \
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER "1"
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    pkg-config
    cargo-tauri_1.hook
    desktop-file-utils
    makeBinaryWrapper
  ];

  buildInputs =
    [
      openssl
      dbus
      glib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      webkitgtk_4_0
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.DarwinTools
      darwin.apple_sdk.frameworks.WebKit
    ];

  meta = {
    description = "Yet another matrix client for desktop";
    homepage = "https://github.com/cinnyapp/cinny-desktop";
    maintainers = with lib.maintainers; [
      qyriad
      ryand56
    ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cinny";
  };
}
