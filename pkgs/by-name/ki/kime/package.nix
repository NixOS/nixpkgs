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
  makeWrapper,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxkbcommon,
  wayland,
  withWayland ? true,
  withIndicator ? true,
  dbus,
  libdbusmenu,
  withXim ? true,
  libxcb,
  cairo,
  withGtk3 ? true,
  gtk3,
  withGtk4 ? true,
  gtk4,
  withQt5 ? true,
  qt5,
  withQt6 ? false,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kime";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "Riey";
    repo = "kime";
    tag = "v${finalAttrs.version}";
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
    # Upstream prepends the install prefix when installing the Cargo library.
    "--libdir=lib"
    (lib.mesonEnable "gtk3" withGtk3)
    (lib.mesonEnable "gtk4" withGtk4)
    (lib.mesonEnable "qt5" withQt5)
    (lib.mesonEnable "qt6" withQt6)
    (lib.mesonEnable "indicator" withIndicator)
    (lib.mesonEnable "xim" withXim)
    (lib.mesonEnable "wayland" withWayland)
    (lib.mesonOption "cargo_profile" "release")
  ]
  ++ lib.optional withQt5 (
    lib.mesonOption "qt5_plugindir" "${placeholder "out"}/${qt5.qtbase.qtPluginPrefix}"
  )
  ++ lib.optional withQt6 (
    lib.mesonOption "qt6_plugindir" "${placeholder "out"}/${qt6.qtbase.qtPluginPrefix}"
  );

  # Qt5 and Qt6 setup hooks cannot be loaded together. Let Meson discover Qt6
  # explicitly when both input modules are enabled.
  preConfigure = lib.optionalString (withQt5 && withQt6) ''
    export PATH="${qt6.qtbase}/bin:$PATH"
    export NIX_LDFLAGS="''${NIX_LDFLAGS:-} -rpath ${lib.getLib qt6.qtbase}/lib"
    export PKG_CONFIG_PATH="${qt6.qtbase}/lib/pkgconfig''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
  '';

  preBuild = ''
    export CARGO_BUILD_JOBS="$NIX_BUILD_CORES"
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    (cd .. && cargo test --release --frozen)
    runHook postCheck
  '';

  # The egui candidate window loads its display and OpenGL libraries at runtime.
  postFixup = ''
    wrapProgram "$out/bin/kime-candidate-window" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libx11
          libxcursor
          libxi
          libxrandr
          libxkbcommon
          wayland
        ]
      }"
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
    libxkbcommon
    wayland
  ]
  ++ lib.optionals withIndicator [
    dbus
    libdbusmenu
  ]
  ++ lib.optionals withXim [
    libxcb
    cairo
  ]
  ++ lib.optionals withGtk3 [ gtk3 ]
  ++ lib.optionals withGtk4 [ gtk4 ]
  ++ lib.optionals withQt5 [ qt5.qtbase ]
  ++ lib.optionals (withQt6 && !withQt5) [ qt6.qtbase ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    makeWrapper
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
