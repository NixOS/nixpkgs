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
  desktopToDarwinBundle,
  versionCheckHook,
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
  version = "0.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "gridcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8qlbNJWvONfZ8BvY8fij1QrLwoikFKBgmTiklpu4LOM=";
  };

  cargoHash = "sha256-9PJmE7dLeDIEsnczga1WfWaad1e0YLLh04rJcSyzGwE=";

  # The mac_menu_appkit test starts a real NSApplication, and AppKit aborts in the build
  # sandbox ("required built-in appearance SystemAppearance not found").
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm apps/gridcraft/tests/mac_menu_appkit.rs
    substituteInPlace apps/gridcraft/Cargo.toml \
      --replace-fail $'[[test]]\nname = "mac_menu_appkit"\nharness = false' ""
  '';

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
  ]
  # Turns the desktop item into Applications/GridCraft.app.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

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
        "xlsb"
        "ods"
        "csv"
        "tsv"
        "excel"
      ];
      mimeTypes = [
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.ms-excel.sheet.macroEnabled.12"
        "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
        "application/vnd.oasis.opendocument.spreadsheet"
        "text/csv"
        "text/tab-separated-values"
      ];
    })
  ];

  # On darwin, desktopToDarwinBundle builds the app icon from these.
  postInstall = ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.gridcraft.mime.xml $out/share/mime/packages/ai.storyteller.gridcraft.xml
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/gridcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spreadsheet app with XLSX, CSV and TSV support";
    homepage = "https://github.com/storytold/gridcraft";
    changelog = "https://github.com/storytold/gridcraft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "gridcraft";
    platforms = rustc.meta.platforms;
  };
})
