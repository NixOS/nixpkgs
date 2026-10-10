{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  makeWrapper,
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
  craftFonts,

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
  version = "0.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craftFonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "lightcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N/V/MIf+8u9zCytsWLIr4muXjmrqfc+o78PFUFhlQS8=";
  };

  cargoHash = "sha256-Z6r3NGsYyE/bdTzuPFjUba6YsxCl9qieDrICeqFpo/A=";

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
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.lightcraft";
      desktopName = "LightCraft";
      genericName = "Photo Editor";
      comment = "Photo library and raw development, a native Lightroom-style editor";
      exec = "lightcraft %F";
      tryExec = "lightcraft";
      icon = "ai.storyteller.lightcraft";
      terminal = false;
      startupWMClass = "lightcraft";
      keywords = [
        "photo"
        "raw"
        "camera"
        "library"
        "develop"
      ];
      mimeTypes = [
        "image/jpeg"
        "image/png"
        "image/tiff"
        "image/webp"
        "image/x-adobe-dng"
        "image/x-sony-arw"
        "image/x-canon-cr2"
        "image/x-canon-cr3"
        "image/x-nikon-nef"
        "image/x-fuji-raf"
        "image/x-olympus-orf"
        "image/x-panasonic-rw2"
        "image/x-pentax-pef"
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

    docdir=$out/share/doc/${finalAttrs.pname}-${finalAttrs.version}
    install -d $docdir
    for lic in ${craftFonts}/fonts/*/OFL.txt; do
      install -Dm644 "$lic" "$docdir/OFL-$(basename "$(dirname "$lic")").txt"
    done
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/lightcraft
    wrapProgram $out/bin/lightcraft --set LIGHTCRAFT_SKIP_LIB_CHECK 1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Photo library and raw development, a native Lightroom-style editor";
    homepage = "https://github.com/storytold/lightcraft";
    changelog = "https://github.com/storytold/lightcraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "lightcraft";
    platforms = rustc.meta.platforms;
  };
})
