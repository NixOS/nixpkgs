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
  pname = "pdfcraft";
  version = "0.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craftFonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "pdfcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qiPNOCr1avy2RyE7nQ79vLI03Nxy/d8/p3HNAqNWdC0=";
  };

  cargoHash = "sha256-2y4jFVHDHUYoKo9gzRb7uq2dhtLa97P1iffRrMw46IQ=";

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
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.pdfcraft";
      desktopName = "PdfCraft";
      genericName = "PDF Editor";
      comment = "Read, organize, combine, split and secure PDFs";
      exec = "pdfcraft %F";
      tryExec = "pdfcraft";
      icon = "ai.storyteller.pdfcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "pdfcraft";
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
        "Graphics"
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
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/pdfcraft
    wrapProgram $out/bin/pdfcraft --set PDFCRAFT_SKIP_LIB_CHECK 1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source PDF workbench for reading, organizing, and securing documents";
    homepage = "https://github.com/storytold/pdfcraft";
    changelog = "https://github.com/storytold/pdfcraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "pdfcraft";
    platforms = rustc.meta.platforms;
  };
})
