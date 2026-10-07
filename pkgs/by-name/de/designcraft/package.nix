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
  pname = "designcraft";
  version = "0.12.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "designcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gPG3Tb0vnmL3HO1iq5G8Rxg85UaVxf5iKJRCIuR3db8=";
  };

  cargoHash = "sha256-WwLq9rKLTjvk5afjTYBdETIyEUoQjXUg/YGF7TAu8GA=";

  cargoBuildFlags = [
    "--package=designcraft"
    "--package=designcraft-cli"
  ];

  # The `designcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=designcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.designcraft";
      desktopName = "DesignCraft";
      genericName = "Page Layout";
      comment = "Lay out magazines, books and print documents";
      exec = "designcraft %F";
      tryExec = "designcraft";
      icon = "ai.storyteller.designcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.designcraft";
      keywords = [
        "layout"
        "page"
        "desktop publishing"
        "dtp"
        "magazine"
        "book"
        "indesign"
        "idml"
        "typesetting"
      ];
      mimeTypes = [
        "application/vnd.adobe.indesign-idml-package"
        "application/x-designcraft"
      ];
      categories = [
        "Graphics"
        "Publishing"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.designcraft.mime.xml $out/share/mime/packages/ai.storyteller.designcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/designcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Page layout and publishing, a native InDesign-style editor";
    homepage = "https://github.com/storytold/designcraft";
    changelog = "https://github.com/storytold/designcraft/releases/tag/v${finalAttrs.version}";
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
    mainProgram = "designcraft";
    platforms = rustc.meta.platforms;
  };
})
