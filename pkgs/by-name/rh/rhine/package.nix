{
  dbus,
  fetchFromCodeberg,
  lib,
  libxkbcommon,
  pkg-config,
  pkgs,
  river,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig_0_16,
  withNotify ? true,
  withDebug ? false,
  ...
}:

let
  inherit (lib.trivial)
    boolToString
    ;
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "0.3.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    tag = finalAttrs.version;
    hash = "sha256-1urSOudD12Ge/hy3mGFfGNQAKLjqvuyV+cO1T4HloYs=";
  };

  nativeBuildInputs = [
    pkg-config
    zig
  ];

  buildInputs = [
    wayland-scanner
    libxkbcommon
    wayland
    dbus
    river
    wayland-protocols
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-wvnECiDfK17uKGySe2SYEkpHL0RdRQTlS+b8zGw2F9g=";
  };

  zigBuildFlags = [
    "-Dnotify=${boolToString withNotify}"
    "-Dstrip=${boolToString withDebug}"
  ];

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  postInstall = ''
    install rhine.desktop -Dt $out/share/wayland-sessions
  '';

  passthru = {
    providedSessions = [ "rhine" ];
  };

  meta = {
    homepage = "https://codeberg.org/sivecano/rhine";
    description = "window manager for river supporting multiple layouts and awesome animations";
    maintainers = with lib.maintainers; [ OulipianSummer ];
    license = with lib.licenses; [
      # rhine
      gpl3Only

      # wayland protocols
      mit
    ];
    mainProgram = "rhine";
    platforms = lib.platforms.linux;
  };
})
