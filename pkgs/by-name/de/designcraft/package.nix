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
  pname = "designcraft";
  version = "0.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craftFonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "designcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aU3DEa+DPKy/ySBhyaCS/7G1QRONYwCmDnXIJhindWE=";
  };

  cargoHash = "sha256-GbQHf8GVm8nB8fcGcIDyhWJY/um9W4y1KRryUd574ws=";

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
    makeWrapper
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
      categories = [
        "Graphics"
        "Publishing"
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
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/designcraft
    wrapProgram $out/bin/designcraft --set DESIGNCRAFT_SKIP_LIB_CHECK 1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Page layout and publishing, a native InDesign-style editor";
    homepage = "https://github.com/storytold/designcraft";
    changelog = "https://github.com/storytold/designcraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "designcraft";
    platforms = rustc.meta.platforms;
  };
})
