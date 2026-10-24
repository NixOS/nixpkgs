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
  pname = "pdfcraft";
  version = "0.13.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "pdfcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DS2jfwzH3LtvEhlxcoSywyDDenvH2N9DkdDVzEP6QdQ=";
  };

  cargoHash = "sha256-w56jGzgk82D67vH3z0aUL49iGMtl9oYQVmgwVZ4EkLc=";

  cargoBuildFlags = [
    "--package=pdfcraft"
    "--package=pdfcraft-cli"
  ];

  # The `pdfcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=pdfcraft-cli"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isx86_64 ''
    i8dot=("$cargoDepsCopy"/source-registry-0/rten-gemm-*/src/i8dot.rs)
    sed -i '/Avx512VnniIsa::new()/,+2d' "$i8dot"
  '';

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.pdfcraft";
      desktopName = "PdfCraft";
      genericName = "PDF Editor";
      comment = "Read, organize, combine, split and secure PDFs";
      exec = "pdfcraft %U";
      tryExec = "pdfcraft";
      icon = "ai.storyteller.pdfcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.pdfcraft";
      keywords = [
        "pdf"
        "viewer"
        "editor"
        "annotate"
        "sign"
        "forms"
        "merge"
        "split"
      ];
      mimeTypes = [ "application/pdf" ];
      categories = [
        "Office"
        "Viewer"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/pdfcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source PDF workbench for reading, organizing, and securing documents";
    homepage = "https://github.com/storytold/pdfcraft";
    changelog = "https://github.com/storytold/pdfcraft/releases/tag/v${finalAttrs.version}";
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
    mainProgram = "pdfcraft";
    platforms = rustc.meta.platforms;
  };
})
