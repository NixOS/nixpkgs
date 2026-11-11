{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  versionCheckHook,
  craft-fonts,
  dbus,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  vulkan-loader,
  wayland,
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
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "photocraft";
  version = "0.16.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "photocraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uaZmzQb4B1zZ2XrZHjHzI/uEVGdoYRFeh10GHIxzjDA=";
  };

  cargoHash = "sha256-O1tUKAWSvLmOEUbpVub8bczHpoXH6XxXKSPGRVkjsHs=";

  cargoBuildFlags = [
    "--package=photocraft"
    "--package=photocraft-cli"
  ];

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  # The `photocraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=photocraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.photocraft";
      desktopName = "PhotoCraft";
      genericName = "Image Editor";
      comment = "Edit photos and layered PSD documents";
      exec = "photocraft %F";
      tryExec = "photocraft";
      icon = "ai.storyteller.photocraft";
      terminal = false;
      startupNotify = false;
      startupWMClass = "ai.storyteller.photocraft";
      categories = [
        "Graphics"
        "2DGraphics"
        "RasterGraphics"
        "Photography"
      ];
      keywords = [
        "photo"
        "image"
        "editor"
        "psd"
        "layers"
        "retouch"
        "paint"
      ];
      mimeTypes = [
        "application/x-krita"
        "application/x-photocraft"
        "image/avif"
        "image/bmp"
        "image/gif"
        "image/jpeg"
        "image/openraster"
        "image/png"
        "image/qoi"
        "image/tiff"
        "image/vnd.adobe.photoshop"
        "image/vnd.microsoft.icon"
        "image/vnd.radiance"
        "image/webp"
        "image/x-exr"
        "image/x-icon"
        "image/x-paintnet"
        "image/x-portable-anymap"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/x-portable-pixmap"
        "image/x-psb"
        "image/x-psd"
        "image/x-tga"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.photocraft.mime.xml $out/share/mime/packages/ai.storyteller.photocraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/photocraft
    wrapProgram $out/bin/photocraft --set PHOTOCRAFT_SKIP_LIB_CHECK 1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source, native image editor with layered PSD/PSB support";
    homepage = "https://github.com/storytold/photocraft";
    changelog = "https://github.com/storytold/photocraft/releases/tag/${finalAttrs.src.tag}";
    # Bundled assets: see ATTRIBUTION.md in upstream.
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
        isc
        cc-by-30
        cc0
        bsd3
        # scowl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "photocraft";
    platforms = rustc.meta.platforms;
  };
})
