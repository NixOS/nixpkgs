{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  alsa-lib,
  dbus,
  glib-networking,
  libayatana-appindicator,
  libsoup_3,
  openssl,
  pcsclite,
  perl,
  pkg-config,
  udev,
  webkitgtk_4_1,
  wrapGAppsHook4,
  sqlite,
}:

let
  # Ratspeak resolves its protocol crates by relative path from sibling
  # checkouts (../rsReticulum and friends). Upstream does not tag the
  # siblings together with every app release, so each one is pinned to the
  # revision current at the v1.0.25 release date.
  rsReticulum = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsReticulum";
    tag = "ratspeak-v1.0.43";
    hash = "sha256-9B+Hn1fCoD9lE+Nmc8o2u3X96rgJXMWY/6Sakm6cCnU=";
  };
  rsLXMF = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXMF";
    tag = "ratspeak-v1.0.43";
    hash = "sha256-j7CjS5UUj6nOCZT7yu7tv20u4JTjKcFxEQVg1MTTbeA=";
  };
  rsLXST = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXST";
    tag = "ratspeak-v1.0.43";
    hash = "sha256-e8+Ary6VpZ/WZJL1si5LqjzQhYD7QNN6o81cOjQCN8g=";
  };
  lrgp-rs = fetchFromGitHub {
    owner = "ratspeak";
    repo = "lrgp-rs";
    tag = "ratspeak-v1.0.43";
    hash = "sha256-9BC58C3PGT/wIUwMti08b457feGkB0BT8WbOOLj0V6Q=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratspeak";
  version = "1.0.43";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "Ratspeak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JD8cxnh5vYgAZsKroJpy6yRxdAhI/ZI4dB0q4zwQ2N0=";
  };

  # The app expects the protocol repos next to its own checkout.
  postUnpack = ''
    cp -r ${rsReticulum} rsReticulum
    cp -r ${rsLXMF} rsLXMF
    cp -r ${rsLXST} rsLXST
    cp -r ${lrgp-rs} lrgp-rs
    chmod -R u+w rsReticulum rsLXMF rsLXST lrgp-rs
  '';

  cargoHash = "sha256-VXduGeMzGvuMLUa/tFk0N+zmbDqh8cwZGs5IAYGHxLQ=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    cargo-tauri.hook
    perl
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    dbus
    glib-networking
    libayatana-appindicator
    libsoup_3
    openssl
    pcsclite
    udev
    webkitgtk_4_1
  ];

  # The dashboard ships modular CSS; the app serves the concatenated file.
  preBuild = ''
    bash dashboard/build-css.sh
  '';

  # The tray icon library is dlopened at runtime, not linked.
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]}
    )
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Reticulum and LXMF client with messaging, file sharing, voice calls and LoRa support";
    homepage = "https://github.com/ratspeak/Ratspeak";
    changelog = "https://github.com/ratspeak/Ratspeak/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      # https://github.com/ratspeak/Ratspeak/blob/v1.0.43/NOTICE
      AND [
        # Ratspeak, rsReticulum, rsLXMF
        reticulum
        # lrgp-rs
        mit
        # rsLXST is distributed under a non-free license that only allows
        # unmodified, non-commercial use with Ratspeak.
        # https://github.com/ratspeak/rsLXST/blob/ratspeak-v1.0.43/LICENSE
        unfreeRedistributable
      ];
    maintainers = with lib.maintainers; [ eldios ];
    platforms = lib.platforms.linux;
    mainProgram = "ratspeak";
  };
})
