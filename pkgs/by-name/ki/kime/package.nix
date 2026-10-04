{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  cargo,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  python3,
  libGL,
  libxkbcommon,
  withWayland ? true,
  wayland,
  withIndicator ? true,
  dbus,
  libdbusmenu,
  withXim ? true,
  libxcb,
  withGtk3 ? true,
  gtk3,
  withGtk4 ? true,
  gtk4,
  withQt5 ? false,
  qt5,
  withQt6 ? true,
  qt6,
}:

assert !(withQt5 && withQt6); # Nixpkgs Qt hooks disallow mixing Qt5 and Qt6 in the same derivation

stdenv.mkDerivation (finalAttrs: {
  pname = "kime";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = "kime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YQQ27pSyuznqOI5o5oqLQIdUPqnrw8UTmD65KL9su3c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-FP7uHsLVozB6kpwCuNFrYY2j6RQUL6n41hfvlFN5/qI=";
  };

  # Replace autostart path
  postPatch = ''
    substituteInPlace res/kime.desktop res/kime-xdg-autostart \
      --replace-warn "/usr/bin/kime" "kime"
  '';

  dontWrapQtApps = true;

  mesonFlags = [
    "-Dcargo_profile=release"
    (lib.mesonEnable "indicator" withIndicator)
    (lib.mesonEnable "xim" withXim)
    (lib.mesonEnable "wayland" withWayland)
    (lib.mesonEnable "gtk3" withGtk3)
    (lib.mesonEnable "gtk4" withGtk4)
    (lib.mesonEnable "qt5" withQt5)
    (lib.mesonEnable "qt6" withQt6)
  ]
  ++ lib.optionals withQt5 [
    "-Dqt5_plugindir=${placeholder "out"}/${qt5.qtbase.qtPluginPrefix}"
  ]
  ++ lib.optionals withQt6 [
    "-Dqt6_plugindir=${placeholder "out"}/${qt6.qtbase.qtPluginPrefix}"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    cargo test --release --frozen
    runHook postCheck
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    # Don't pipe output to head directly it will cause broken pipe error https://github.com/rust-lang/rust/issues/46016
    kimeVersion=$(echo "$($out/bin/kime --version)" | head -n1)
    echo "'kime --version | head -n1' returns: $kimeVersion"
    [[ "$kimeVersion" == "kime ${finalAttrs.version}" ]]
    runHook postInstallCheck
  '';

  buildInputs = [
    libGL
    libxkbcommon
  ]
  ++ lib.optionals withIndicator [
    dbus
    libdbusmenu
  ]
  ++ lib.optionals withXim [
    libxcb
  ]
  ++ lib.optionals withWayland [
    wayland
  ]
  ++ lib.optionals withGtk3 [ gtk3 ]
  ++ lib.optionals withGtk4 [ gtk4 ]
  ++ lib.optionals withQt5 [ qt5.qtbase ]
  ++ lib.optionals withQt6 [ qt6.qtbase ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  env = {
    RUST_BACKTRACE = 1;
  };

  meta = {
    homepage = "https://github.com/Riey/kime";
    description = "Korean IME";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.riey ];
    platforms = lib.platforms.linux;
  };
})
