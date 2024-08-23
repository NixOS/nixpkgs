{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  cinny,
  desktop-file-utils,
  wrapGAppsHook3,
  pkg-config,
  openssl,
  dbus,
  glib,
  glib-networking,
  libayatana-appindicator,
  webkitgtk,
}:

rustPlatform.buildRustPackage rec {
  pname = "cinny-desktop";
  # We have to be using the same version as cinny-web or this isn't going to work.
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny-desktop";
    rev = "refs/tags/v${version}";
    hash = "sha256-W73ma8ScF3LGv45yhZCV80zhh7URLuWhbi+JumyTp+4=";
  };

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-ved2W4+Dt7pN9j9vIaDlAkaY517nBEgPKgu8ArcHXsM=";

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
        --replace '"distDir": "../cinny/dist",' '"distDir": "${cinny'}",'
      substituteInPlace tauri.conf.json \
        --replace '"cd cinny && npm run build"' '""'
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
        --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      ln -sf "$out/Applications/Cinny.app/Contents/MacOS/Cinny" "$out/bin/cinny"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      desktop-file-edit \
        --set-comment "Yet another matrix client for desktop" \
        --set-key="Categories" --set-value="Network;InstantMessaging;" \
        $out/share/applications/cinny.desktop
    '';

  nativeBuildInputs = [
    wrapGAppsHook3
    pkg-config
    cargo-tauri.hook
    desktop-file-utils
  ];

  buildInputs =
    [
      openssl
      dbus
      glib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      libayatana-appindicator
      webkitgtk
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
