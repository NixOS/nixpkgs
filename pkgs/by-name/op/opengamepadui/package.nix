{
  alsa-lib,
  autoPatchelfHook,
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
  version = "0.37.0";

  buildType = if withDebug then "debug" else "release";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "OpenGamepadUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kzGFyzOu4Pkj+a7kExFwxFu35qfoLoWz3uqd8COUTNA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    sourceRoot = "source/${finalAttrs.cargoRoot}";
    hash = "sha256-T79G2bShJuFRfaCqG3IDHqW0s68yAdGyv58kdDYg6kg=";
  };
  cargoRoot = "extensions";

  nativeBuildInputs = [
    autoPatchelfHook
    cargo
    godot_4_4
    godot_4_4.export-templates-bin
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  runtimeDependencies = [
    alsa-lib
    dbus
    gamescope
    hwdata
    libGL
    libpulseaudio
    mesa-demos
    udev
    upower
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
    xorg.libXres
    xorg.libXtst
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
      EXPORT_TEMPLATE = "${godot_4_4.export-templates-bin}";
      BUILD_TYPE = "${finalAttrs.buildType}";
    };

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "build" ];

  preBuild = ''
    # Godot looks for export templates in HOME
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/export_templates
    ln -s "${godot_4_4.export-templates-bin}" "$HOME/.local/share/godot/export_templates/$GODOT_VERSION.$GODOT_RELEASE"
  '';

  postInstall = ''
    # The Godot binary looks in "../lib" for gdextensions
    mkdir -p $out/share/lib
    mv $out/share/opengamepadui/*.so $out/share/lib
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
