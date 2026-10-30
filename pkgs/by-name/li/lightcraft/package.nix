{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  copyDesktopItems,
  makeDesktopItem,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  craft-fonts,

  nix-update-script,
}:

let
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    wayland
    vulkan-loader
    libxrandr
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lightcraft";
  version = "0.14.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "lightcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v6UZTeyxzDZ1bFoYGwvwv6tF11qQNXf4ib8siGjpcHU=";
  };

  cargoHash = "sha256-dM3yj2Jux7zlk9ycTxY3++D/rKIkEqsyAkM304Ute3k=";

  cargoBuildFlags = [
    "--package=lightcraft"
    "--package=lightcraft-cli"
  ];

  # The `lightcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=lightcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.lightcraft";
      desktopName = "LightCraft";
      genericName = "Photo Library and Raw Developer";
      comment = "Organise photos and develop raw files, non-destructively";
      exec = "lightcraft %F";
      icon = "ai.storyteller.lightcraft";
      terminal = false;
      startupWMClass = "ai.storyteller.lightcraft";
      keywords = [
        "photo"
        "raw"
        "camera"
        "library"
        "develop"
      ];
      mimeTypes = [
        "image/heic"
        "image/heif"
        "image/jpeg"
        "image/png"
        "image/tiff"
        "image/webp"
        "image/x-adobe-dng"
        "image/x-canon-cr2"
        "image/x-canon-cr3"
        "image/x-fuji-raf"
        "image/x-nikon-nef"
        "image/x-olympus-orf"
        "image/x-panasonic-rw"
        "image/x-panasonic-rw2"
        "image/x-pentax-pef"
        "image/x-sony-arw"
      ];
      categories = [
        "Graphics"
        "2DGraphics"
        "RasterGraphics"
        "Photography"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/lightcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Photo library and raw development, a native Lightroom-style editor";
    homepage = "https://github.com/storytold/lightcraft";
    changelog = "https://github.com/storytold/lightcraft/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "lightcraft";
    platforms = rustc.meta.platforms;
  };
})
