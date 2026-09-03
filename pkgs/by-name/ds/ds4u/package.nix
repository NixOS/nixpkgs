{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  systemd,
  hidapi,
  openssl,
  libxkbcommon,
  alsa-lib,
  vulkan-loader,
  wayland,
  libx11,
  libxcursor,
  libxi,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  udevCheckHook,
  writeText,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ds4u";
  version = "0.1.1";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "git.yokai.digital";
    owner = "deadYokai";
    repo = "ds4u";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q8NbpFbrYMtE56CnnjScbMewHCTxaxMih8/I9dspb+o=";
  };

  cargoHash = "sha256-KjNHX3S+XFUsngX8Od3HtI0IvpAyMp5TB6TVkCkl8Gc=";

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    libxkbcommon
    vulkan-loader
    wayland
    libx11
    libxcursor
    libxi
    openssl
    systemd
    hidapi
  ];

  # autoPatchelfHook doesnt find these automatically using dlopen
  appendRunpaths = [ (lib.makeLibraryPath finalAttrs.buildInputs) ];

  udevRules = writeText "ds4u.rules" ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0664", GROUP="input", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0df2", MODE="0664", GROUP="input", TAG+="uaccess"
  '';

  preInstall = ''
    # desktop icon install
    install -Dm644 $src/assets/icon.svg $out/share/icons/hicolor/scalable/apps/ds4u.svg
    # udev rules
    install -Dm644 ${finalAttrs.udevRules} -D $out/lib/udev/rules.d/70-ds4u.rules
  '';

  nativeInstallCheckInputs = [ udevCheckHook ];
  doInstallCheck = true;

  desktopItems = [
    (makeDesktopItem {
      name = "ds4u";
      desktopName = "DS4U";
      comment = finalAttrs.meta.description;
      exec = "ds4u";
      icon = "ds4u";
      terminal = false;
      type = "Application";
      categories = [
        "Utility"
        "Settings"
        "Game"
      ];
      keywords = [
        "controller"
        "dualsense"
        "ps5"
        "gamepad"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "DualSense controller manager for Linux";
    homepage = "https://git.yokai.digital/deadYokai/ds4u";
    license = lib.licenses.mit;
    mainProgram = "ds4u";
    maintainers = with lib.maintainers; [ cakeforcat ];
    platforms = lib.platforms.linux;
  };
})
