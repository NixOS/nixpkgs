{
  lib,
  rustPlatform,
  pkg-config,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  iconConvTools,
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
  python3,
  ibus,
  glib,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      pygobject3
      (toPythonModule ibus)
    ]
  );
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ergohaven-entropy";
  version = "0.3.20";

  src = fetchFromGitHub {
    owner = "ergohaven";
    repo = "entropy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8RvndwWHNnktqGXDzBOml8jBzHTH6SRtiwx/qIpuYq8=";
  };

  cargoHash = "sha256-8Gbdf2BLF2QYDXwYp1rCUEfjE62/sQLc+6vm5avIppo=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    copyDesktopItems
    iconConvTools
    python
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

  desktopItems = lib.singleton (makeDesktopItem {
    name = "entropy";
    exec = "entropy";
    icon = "entropy";
    desktopName = "Entropy";
    comment = "Configure programmable keyboards and input devices";
    categories = [
      "Settings"
      "HardwareSettings"
    ];
  });

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cat > $out/lib/udev/rules.d/59-vial.rules << RULES
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="plugdev", TAG+="uaccess"
    RULES

    icoFileToHiColorTheme $src/assets/entropy.ico entropy $out

    install -Dm755 $src/linux/ibus/entropy-ibus-engine $out/share/entropy/ibus/entropy-ibus-engine
    mkdir -p $out/share/ibus/component
    substitute $src/linux/ibus/entropy-universal-symbols.xml.in \
      $out/share/ibus/component/entropy-universal-symbols.xml \
      --replace-fail "@ENGINE_PATH@" "$out/share/entropy/ibus/entropy-ibus-engine"

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

  postFixup = ''
    patchShebangs --build $out/share/entropy/ibus/entropy-ibus-engine
    wrapProgram $out/share/entropy/ibus/entropy-ibus-engine \
      --prefix GI_TYPELIB_PATH : ${
        lib.makeSearchPath "lib/girepository-1.0" [
          glib
          ibus
        ]
      }
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
