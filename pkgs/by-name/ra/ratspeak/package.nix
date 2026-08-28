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
    tag = "v1.2.0";
    hash = "sha256-gdup7PaYOQnBE3Mm4adpjQh5W3DaXWrdmuUhj5cF0ZE=";
  };
  rsLXMF = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXMF";
    tag = "v1.2.0";
    hash = "sha256-5YV/XHpBoqN+XoE6Nf/zqq9JRAcMZKqWLsseRqZVt6o=";
  };
  rsLXST = fetchFromGitHub {
    owner = "ratspeak";
    repo = "rsLXST";
    tag = "v0.2.0";
    hash = "sha256-XLdA0kprtPEkJmnKJM4dhzoN0wb/jWzk1qP0jNyFw7I=";
  };
  lrgp-rs = fetchFromGitHub {
    owner = "ratspeak";
    repo = "lrgp-rs";
    tag = "v0.4.1";
    hash = "sha256-SgdQZpVmJjB/g1OnW2/Gx3fwtrcUC+2UQy88gvMTDUw=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratspeak";
  version = "1.0.31";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ratspeak";
    repo = "Ratspeak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cvvjZNr0b9Q9PX6UqKFIHoPArWQGZ7fwFRgh5uJPQdg=";
  };

  # The app expects the protocol repos next to its own checkout.
  postUnpack = ''
    cp -r ${rsReticulum} rsReticulum
    cp -r ${rsLXMF} rsLXMF
    cp -r ${rsLXST} rsLXST
    cp -r ${lrgp-rs} lrgp-rs
    chmod -R u+w rsReticulum rsLXMF rsLXST lrgp-rs
  '';

  cargoHash = "sha256-zf3582SkmrWdWYoTIyN3tGNGF5PhxyU1ZpTwf8uKDvo=";
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
