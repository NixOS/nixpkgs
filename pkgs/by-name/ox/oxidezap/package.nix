{
  lib,
  rustPlatform,
  runtimeShell,
  fetchFromGitHub,
  pkg-config,
  cmake,
  nasm,
  protobuf,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  adwaita-icon-theme-legacy,
  fontconfig,
  makeFontsConf,
  dejavu_fonts,
  freetype,
  libxkbcommon,
  libxcb,
  wayland,
  vulkan-loader,
  libGL,
  sqlite,
  libopus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxidezap";
  version = "0-unstable-2026-11-16";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oxidezap";
    repo = "client";
    rev = "075bcd4d08be58db6612b6429df0dde405c0c478";
    hash = "sha256-/NHRVS9aK6Ad7KYnAKF9HIjaU54i+cN0Ip39z3UiC+4=";
  };

  cargoHash = "sha256-QznXAPrVqXw7dlSn2ApjV3qbXfQYqurxmP3iKBiUt88=";

  nativeBuildInputs = [
    pkg-config
    cmake
    nasm
    protobuf
    makeBinaryWrapper
    copyDesktopItems
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    libxkbcommon
    libxcb
    wayland
    sqlite
    libopus
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    # The native workspace still builds with the Rust version in Nixpkgs.
    substituteInPlace Cargo.toml \
      --replace-fail 'rust-version = "1.100.0"' 'rust-version = "1.99.1"'

    # Use the Nixpkgs linker and system SQLite configuration.
    rm .cargo/config.toml

    # The daemon's launch tests create an executable shell script.
    substituteInPlace crates/daemon/src/window/native.rs \
      --replace-fail '#!/bin/sh' '#!${runtimeShell}'

    # Tray hosts may not resolve these names in their own icon theme.
    substituteInPlace crates/daemon/src/tray/linux.rs \
      --replace-fail '"user-offline"' '"${adwaita-icon-theme-legacy}/share/icons/AdwaitaLegacy/32x32/legacy/user-offline.png"' \
      --replace-fail '"user-available"' '"${adwaita-icon-theme-legacy}/share/icons/AdwaitaLegacy/32x32/legacy/user-available.png"' \
      --replace-fail '"mail-unread"' '"${adwaita-icon-theme-legacy}/share/icons/AdwaitaLegacy/32x32/legacy/mail-unread.png"'

    # Link against the maintained system Opus instead of the bundled copy.
    substituteInPlace $cargoDepsCopy/*/opusic-sys-*/Cargo.toml \
      --replace-fail 'default = ["bundled"]' 'default = []'
  '';

  env = {
    # Full LTO across the GUI and daemon is expensive in build time and memory.
    CARGO_PROFILE_RELEASE_LTO = "thin";
    OXIDEZAP_REV = finalAttrs.src.rev;
    LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
    OPUS_LIB_DIR = "${lib.getLib libopus}/lib";
  };

  cargoBuildFlags = [
    "--bin=oxidezap"
    "--bin=oxidezapd"
    "--bin=oxidezap-cli"
  ];

  cargoTestFlags = [
    "--workspace"
    "--all-features"
  ];

  checkType = "debug";

  preCheck = ''
    # GPUI's layout tests need a real font in the sandbox.
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ dejavu_fonts ]; }}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "org.oxidezap.client.local";
      desktopName = "OxideZap";
      comment = "WhatsApp client";
      exec = "oxidezap";
      icon = "org.oxidezap.client.local";
      startupWMClass = "org.oxidezap.client.local";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      startupNotify = true;
    })
  ];

  postInstall = ''
    install -Dm644 packaging/linux/org.oxidezap.client.local.png \
      $out/share/pixmaps/org.oxidezap.client.local.png
  '';

  postFixup = ''
    wrapProgram $out/bin/oxidezap \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libxkbcommon
          wayland
          vulkan-loader
          libGL
        ]
      }
  '';

  meta = {
    description = "Unofficial WhatsApp client with a GPUI desktop interface";
    homepage = "https://github.com/oxidezap/client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.domenkozar ];
    mainProgram = "oxidezap";
    platforms = lib.platforms.linux;
  };
})
