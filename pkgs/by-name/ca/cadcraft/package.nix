{
  lib,
  stdenv,
  rustPlatform,
  rustc,
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
  pname = "cadcraft";
  version = "0.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "cadcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VFw6np9BSOdBQrKlIiNnQ0kKKNfGnYMctbceBpmE778=";
  };

  cargoHash = "sha256-R0nr3XMPU8nL9qV05bHDqW0YGa3pk3mu4kXIF31pm2U=";

  cargoBuildFlags = [
    "--package=cadcraft"
    "--package=cadcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.cadcraft";
      desktopName = "CADCraft";
      genericName = "Computer-Aided Design";
      comment = "Draft, dimension and plot 2D drawings; open DXF and DWG files";
      exec = "cadcraft %F";
      tryExec = "cadcraft";
      icon = "ai.storyteller.cadcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.cadcraft";
      categories = [
        "Graphics"
        "Engineering"
        "VectorGraphics"
      ];
      keywords = [
        "cad"
        "drafting"
        "dxf"
        "dwg"
        "drawing"
        "engineering"
        "architecture"
        "mechanical"
      ];
      mimeTypes = [
        "image/vnd.dxf"
        "image/vnd.dwg"
        "application/x-dxf"
        "application/acad"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.cadcraft.mime.xml $out/share/mime/packages/ai.storyteller.cadcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/cadcraft
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "2D drafting app for DXF and DWG drawings";
    homepage = "https://github.com/storytold/cadcraft";
    changelog = "https://github.com/storytold/cadcraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "cadcraft";
    platforms = rustc.meta.platforms;
  };
})
