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
  pname = "gridcraft";
  version = "0.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "gridcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C7MOB7YvkYG3aE3PAEtRChdYCRi2tTfu6d/qQhTNX+c=";
  };

  cargoHash = "sha256-lYyBPwE04DrNzUtYPV3aH0mDFuryE/AWesDzV8W2NqA=";

  cargoBuildFlags = [
    "--package=gridcraft"
    "--package=gridcraft-cli"
  ];

  # The gridcraft-mcp tests talk to a fake app over a loopback TCP socket.
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.gridcraft";
      desktopName = "GridCraft";
      genericName = "Spreadsheet";
      comment = "Calculate, analyse and chart data in workbooks";
      exec = "gridcraft %F";
      tryExec = "gridcraft";
      icon = "ai.storyteller.gridcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.gridcraft";
      categories = [
        "Office"
        "Spreadsheet"
      ];
      keywords = [
        "spreadsheet"
        "workbook"
        "sheet"
        "table"
        "formula"
        "chart"
        "pivot"
        "xlsx"
        "csv"
        "tsv"
        "excel"
      ];
      mimeTypes = [
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.ms-excel.sheet.macroEnabled.12"
        "text/csv"
        "text/tab-separated-values"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.gridcraft.mime.xml $out/share/mime/packages/ai.storyteller.gridcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/gridcraft
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spreadsheet app with XLSX, CSV and TSV support";
    homepage = "https://github.com/storytold/gridcraft";
    changelog = "https://github.com/storytold/gridcraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "gridcraft";
    platforms = rustc.meta.platforms;
  };
})
