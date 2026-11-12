{
  dbus,
  fetchFromCodeberg,
  lib,
  libxkbcommon,
  nix-update-script,
  pkg-config,
  river,
  river-channel,
  stdenv,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zig_0_17,
  withStripDebug ? true,
}:

let
  inherit (lib.trivial)
    boolToString
    ;
  zig = zig_0_17;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rhine";
  version = "0.5.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "Sivecano";
    repo = "rhine";
    tag = finalAttrs.version;
    hash = "sha256-BwNMQe6aVUmTyRzkAnwubgYmyXZksxJOjDrfew9xZXI=";
  };

  nativeBuildInputs = [
    pkg-config
    zig
  ];

  buildInputs = [
    libxkbcommon
    wayland
    # wayland-scanner must be placed in buildInputs in order for build to succeed
    wayland-scanner
    river
    wayland-protocols
    river-channel
    dbus
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-ScevH+3LjMCuYZqwufO6+XdipkDB1WGNIUexUERSdqY=";
  };

  zigBuildFlags = [
    "-Dstrip=${boolToString withStripDebug}"
  ];

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  passthru = {
    providedSessions = [ "rhine" ];
    updateScript = nix-update-script { };
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
  };
})
