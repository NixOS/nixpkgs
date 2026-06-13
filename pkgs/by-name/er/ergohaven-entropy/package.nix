{
  lib,
  rustPlatform,
  pkg-config,
  makeWrapper,
  hidapi,
  systemd,
  libxcb,
  libxkbcommon,
  xkeyboard-config,
  openssl,
  gtk3,
  libglvnd,
  libx11,
  libXrandr,
  wayland,
  stdenv,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ergohaven-entropy";
  version = "1.13.151";

  # TODO: switch back to ergohaven/entropy once upstream provides Cargo.lock and tags
  src = fetchFromGitHub {
    owner = "geekiot-hub";
    repo = "entropy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-axbMUDdUpUePoYxu3dTZ4lGTF4FAo7UP5/VMOD3+fHM=";
  };

  cargoHash = "sha256-AmmKAy5xFnShJTYYCMMOaCoT3kgoVaZzcOJrHvk+7NA=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    hidapi
    systemd
    libxcb
    libxkbcommon
    openssl
    gtk3
    libglvnd
    libx11
    libXrandr
    wayland
    xkeyboard-config
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  postInstall = ''
        mkdir -p $out/lib/udev/rules.d
        cat > $out/lib/udev/rules.d/59-vial.rules << RULES
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="plugdev", TAG+="uaccess"
    RULES

        wrapProgram $out/bin/entropy \
          --prefix LD_LIBRARY_PATH : ${
            lib.makeLibraryPath [
              wayland
              libglvnd
              libxkbcommon
            ]
          } \
          --set XKB_CONFIG_ROOT ${xkeyboard-config}/share/X11/xkb
  '';

  meta = {
    description = "Modern app for programmable keyboards and input devices";
    longDescription = ''
      Entropy is a desktop app with a modern, minimalist, and intuitive
      interface for configuring programmable input devices running Vial-QMK
      or Vial-RMK firmware: split keyboards, macropads, trackballs, touchpad
      modules, and other hardware that exposes keyboard-style firmware
      features through HID.
    '';
    homepage = "https://github.com/ergohaven/entropy";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ geekiot-hub ];
    mainProgram = "entropy";
  };
})
