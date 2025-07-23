{
  alsa-lib,
  cargo,
  dbus,
  fetchFromGitHub,
  gamescope,
  godot_4_4,
  hwdata,
  lib,
  libGL,
  libpulseaudio,
  mesa-demos,
  nix-update-script,
  pkg-config,
  rustPlatform,
  stdenv,
  udev,
  upower,
  vulkan-loader,
  xorg,
  withDebug ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opengamepadui";
  version = "0.40.3";

  buildType = if withDebug then "debug" else "release";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "OpenGamepadUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ggCVNWh36q/clYMzObhhxU39qacWSb6urgXOI9yfQeo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-vgaa7Pe0lksiGEpQbn2he5CzhVWoHUSPuXqCwSkoDco=";
  };
  cargoRoot = "extensions";

  nativeBuildInputs = [
    cargo
    godot_4_4
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  dontStrip = withDebug;

  env =
    let
      versionAndRelease = lib.splitString "-" godot_4_4.version;
    in
    {
      GODOT = lib.getExe godot_4_4;
      GODOT_VERSION = lib.elemAt versionAndRelease 0;
      GODOT_RELEASE = lib.elemAt versionAndRelease 1;
      EXPORT_TEMPLATE = "${godot_4_4.export-template}/share/godot/export_templates";
      BUILD_TYPE = "${finalAttrs.buildType}";
    };

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "build" ];

  preBuild = ''
    # Godot looks for export templates in HOME
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/
    ln -s "$EXPORT_TEMPLATE" "$HOME"/.local/share/godot/
  '';

  postInstall =
    let
      runtimeDependencies = [
        gamescope
        hwdata
        mesa-demos
        udev
        upower
      ];
    in
    ''
      # The Godot binary looks in "../lib" for gdextensions
      mkdir -p $out/share/lib
      mv $out/share/opengamepadui/*.so $out/share/lib
      patchelf --add-rpath ${lib.makeLibraryPath runtimeDependencies} $out/share/lib/*.so
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source gamepad-native game launcher and overlay";
    homepage = "https://github.com/ShadowBlip/OpenGamepadUI";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    changelog = "https://github.com/ShadowBlip/OpenGamepadUI/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "opengamepadui";
  };
})
