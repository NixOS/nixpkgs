{
  dbus,
  fetchFromCodeberg,
  lib,
  libxkbcommon,
  pkg-config,
  pkgs,
  river,
  river-channel,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig_0_16,
  withNotify ? true,
  withStripDebug ? true,
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
  version = "0.4.1";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    tag = finalAttrs.version;
    hash = "sha256-wJPwooj1f1xb+DhnxaF6iDD9NASlgQZ1OPgrtCCXtoQ=";
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
    river-channel
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-nePZDV4TnFdI20cvhmyRoNi4OG33f+bvRPOE1xbrG4E=";
  };

  zigBuildFlags = [
    "-Dnotify=${boolToString withNotify}"
    "-Dstrip=${boolToString withStripDebug}"
  ];

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  passthru = {
    providedSessions = [ "rhine" ];
  };

  meta = {
    homepage = "https://codeberg.org/sivecano/rhine";
    description = "window manager for river supporting multiple layouts and awesome animations";
    maintainers = with lib.maintainers; [
      OulipianSummer
      atemu
    ];
    license = with lib.licenses; [
      gpl3Only
    ];
    mainProgram = "rhine";
    platforms = river.meta.platforms;
  };
})
