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
  # rsLXST is an optional, experimental dependency
  withExperimentalVoice ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratspeak";
  version = "1.1.1";
  __structuredAttrs = true;

  srcs = [
    (fetchFromGitHub {
      name = "ratspeak";
      owner = "ratspeak";
      repo = "Ratspeak";
      tag = "v${finalAttrs.version}";
      hash = "sha256-nOoCXT7UTzpgToWVEvlKTK8JdC7YdCDnswh2Td83/7E=";
    })
    # The app expects the protocol repos next to its own checkout.
    # rsLXST must be in tree even when it's disabled for the build. See:
    # https://docs.ratspeak.org/docs/reference/building-from-source#common-build-problems
    # Ratspeak resolves its protocol crates by relative path from sibling
    # checkouts (../rsReticulum and friends). Upstream does not tag the
    # siblings together with every app release, so each one is pinned to the
    # revision current at the v1.0.25 release date.
    (fetchFromGitHub {
      name = "rsReticulum";
      owner = "ratspeak";
      repo = "rsReticulum";
      tag = "ratspeak-v${finalAttrs.version}";
      hash = "sha256-wp9qTj7wL8D/JG1C4GYrI8/n0gPAUGp0iuv2ZzBtkh4=";
    })
    (fetchFromGitHub {
      name = "rsLXMF";
      owner = "ratspeak";
      repo = "rsLXMF";
      tag = "ratspeak-v${finalAttrs.version}";
      hash = "sha256-r8O1+e7/h553vXmdS0FdabZY5IbrrHjOs4EC+5BytQc=";
    })
    (fetchFromGitHub {
      name = "rsLXST";
      owner = "ratspeak";
      repo = "rsLXST";
      tag = "ratspeak-v${finalAttrs.version}";
      hash = "sha256-df/B3fwlIk1d7N8FeKqS7JyNv1gRFa/Bb2d2xjYGPd4=";
    })
    (fetchFromGitHub {
      name = "lrgp-rs";
      owner = "ratspeak";
      repo = "lrgp-rs";
      tag = "ratspeak-v${finalAttrs.version}";
      hash = "sha256-9BC58C3PGT/wIUwMti08b457feGkB0BT8WbOOLj0V6Q=";
    })
  ];

  sourceRoot = "ratspeak";

  cargoHash = "sha256-qvESPXDxKJEXAWNimvSL9murCHG4mvG94kQvvcHAjN4=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  buildNoDefaultFeatures = !withExperimentalVoice;

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
    changelog = "https://github.com/ratspeak/Ratspeak/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      # https://github.com/ratspeak/Ratspeak/blob/v1.0.43/NOTICE
      AND (
        [
          # Ratspeak, rsReticulum, rsLXMF
          reticulum
          # lrgp-rs
          mit
        ]
        # rsLXST is distributed under a non-free license that only allows
        # unmodified, non-commercial use with Ratspeak.
        # https://github.com/ratspeak/rsLXST/blob/ratspeak-v1.0.43/LICENSE
        ++ lib.optional withExperimentalVoice unfreeRedistributable
      );
    maintainers = with lib.maintainers; [ eldios ];
    platforms = lib.platforms.linux;
    mainProgram = "ratspeak";
  };
})
