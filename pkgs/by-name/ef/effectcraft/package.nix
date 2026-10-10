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
  alsa-lib,
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
    alsa-lib
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "effectcraft";
  version = "0.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craftFonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "effectcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Yv2dcN8DSLzF2QTmz3FCW3Hr7yFMemjxEgCW7jTGeU=";
  };

  cargoHash = "sha256-ovareokcWnGDe2GxyZFSfxU/on2Ad3QLnoSTHkswVB4=";

  cargoBuildFlags = [
    "--package=effectcraft"
    "--package=effectcraft-cli"
  ];

  # The `effectcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=effectcraft-cli"
  ];

  buildInputs = [ alsa-lib ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.effectcraft";
      desktopName = "EffectCraft";
      genericName = "Motion Graphics";
      comment = "Motion graphics and visual effects, a native After Effects-style compositor";
      exec = "effectcraft %F";
      tryExec = "effectcraft";
      icon = "ai.storyteller.effectcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.effectcraft";
      keywords = [
        "motion"
        "graphics"
        "animation"
        "compositor"
        "effects"
        "keyframe"
        "vfx"
      ];
      categories = [
        "AudioVideo"
        "Video"
        "Graphics"
        "2DGraphics"
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
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/effectcraft
    wrapProgram $out/bin/effectcraft --set EFFECTCRAFT_SKIP_LIB_CHECK 1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Motion graphics and visual effects, a native After Effects-style compositor";
    homepage = "https://github.com/storytold/effectcraft";
    changelog = "https://github.com/storytold/effectcraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "effectcraft";
    platforms = rustc.meta.platforms;
  };
})
