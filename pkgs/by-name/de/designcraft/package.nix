{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  copyDesktopItems,
  makeDesktopItem,
  desktopToDarwinBundle,
  craft-fonts,
  versionCheckHook,
  alsa-lib,
  aws-lc,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  nix-update-script,
}:

let
  # Loaded with dlopen by winit, wgpu and rfd (libdbus, for the file dialogs).
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "designcraft";
  version = "0.20.1";

  __structuredAttrs = true;

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "designcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rsQfF66CymQ46Ty+RG76A46d6mD8HcMHCOH9EE6sog4=";
  };

  cargoHash = "sha256-BmlQ/G1pBW34W13sTz8jPi/kbzrtB5ZcTyrNOXgpidE=";

  cargoBuildFlags = [
    "--package=designcraft"
    "--package=designcraft-cli"
  ];

  cargoTestFlags = [
    "--package=designcraft-cli"
  ];

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
    substituteInPlace apps/designcraft/src/main.rs \
      --replace-fail 'app.set_startup_update_check(true);' 'app.set_startup_update_check(false);'
  '';

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    aws-lc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.designcraft";
      desktopName = "DesignCraft";
      genericName = "Page layout";
      comment = "Lay out magazines, books and print documents";
      exec = "designcraft %F";
      tryExec = "designcraft";
      icon = "ai.storyteller.designcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.designcraft";
      categories = [
        "Graphics"
        "Publishing"
      ];
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
        "application/x-designcraft"
        "application/vnd.adobe.indesign-idml-package"
      ];
    })
  ];

  postInstall = ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.designcraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.designcraft.xml
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
    changelog = "https://github.com/storytold/designcraft/releases/tag/${finalAttrs.src.tag}";
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
  };
})
