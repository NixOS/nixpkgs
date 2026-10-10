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
  pname = "filmcraft";
  version = "0.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craftFonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "filmcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X/pSYTJbacvEqnVrLgTROo0PVYNZirdNwPhlANk+AgI=";
  };

  cargoHash = "sha256-uzDeo+94RAK/flnYgTic167BeYfk2zqwwf/ODbwnok0=";

  cargoBuildFlags = [
    "--package=filmcraft"
    "--package=filmcraft-cli"
  ];

  # The `filmcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=filmcraft-cli"
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
      name = "ai.storyteller.filmcraft";
      desktopName = "FilmCraft";
      genericName = "Video Editor";
      comment = "Video editing, color and sound, a native Premiere Pro-style editor";
      exec = "filmcraft %F";
      tryExec = "filmcraft";
      icon = "ai.storyteller.filmcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.filmcraft";
      keywords = [
        "video"
        "editor"
        "film"
        "timeline"
        "color"
        "grading"
        "nle"
      ];
      categories = [
        "AudioVideo"
        "Video"
        "AudioVideoEditing"
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
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/filmcraft
    wrapProgram $out/bin/filmcraft --set FILMCRAFT_SKIP_LIB_CHECK 1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Video editing, color and sound, a native Premiere Pro-style editor";
    homepage = "https://github.com/storytold/filmcraft";
    changelog = "https://github.com/storytold/filmcraft/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "filmcraft";
    platforms = rustc.meta.platforms;
  };
})
