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
}:

let
  # Ratspeak resolves its protocol crates by relative path from sibling
  # checkouts (../rsReticulum and friends). Upstream does not tag the
  # siblings together with every app release, so each one is pinned to the
  # revision current at the v1.0.25 release date.
  rsReticulum = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsReticulum";
    rev = "17e6107aa8fb9a5b0c2cac2f4fe4b68655593bd8";
    hash = "sha256-0HjeGZ57eiz9z9akc+ESdZLAN+/uR9LyNaMLgYiTPO8=";
  };
  rsLXMF = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXMF";
    rev = "393478019b3a076abc7af5f0d2c7b980b3329550";
    hash = "sha256-uCoU4HtdRy6sB8vi5BtifKFAy0a7FPuHuuRb1EJTJ2c=";
  };
  rsLXST = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXST";
    rev = "e3f80815bcf1c1d6af1c07135dfe05b6163d596a";
    hash = "sha256-921xMNdneOTurUoUR5ImPEB8ztfEQLl9jCZY+s9Cjuo=";
  };
  lrgp-rs = fetchFromGitHub {
    owner = "ratspeak";
    repo = "lrgp-rs";
    rev = "0b55361ebf91c1caa09d5ed8ab88ac0a6d955de6";
    hash = "sha256-MZGWGCWLc+suHCD9NFV6m8A4EP4pLfogaqm93pMk/ss=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratspeak";
  version = "1.0.25";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "Ratspeak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HJH31dAnmSK85AkX+ufvmo+Nmd9X6xmLO06Lys8kces=";
  };

  # The app expects the protocol repos next to its own checkout.
  postUnpack = ''
    cp -r ${rsReticulum} rsReticulum
    cp -r ${rsLXMF} rsLXMF
    cp -r ${rsLXST} rsLXST
    cp -r ${lrgp-rs} lrgp-rs
    chmod -R u+w rsReticulum rsLXMF rsLXST lrgp-rs
  '';

  cargoHash = "sha256-XumEJazJux0FFLS6qcruaXdOLsZ9hfn8Q/hA9Ot4RzM=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    cargo-tauri.hook
    perl
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
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
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ eldios ];
    platforms = lib.platforms.linux;
    mainProgram = "ratspeak";
  };
})
