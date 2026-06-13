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
  libxrandr,
  wayland,
  stdenv,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ergohaven-entropy";
  version = "1.13.151";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ergohaven";
    repo = "entropy";
    rev = "9ab035d02e6064760c495ae4280e4e6100c5e909";
    hash = "sha256-fUiY04Y+XDzZob1clcRraXHwyOHR0XjjLanHUkH6GsA=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

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
    libxrandr
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
