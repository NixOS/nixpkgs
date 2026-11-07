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
  alsa-lib,
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
    alsa-lib
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "filmcraft";
  version = "0.13.0";

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    CRAFT_FONTS_DIR = "${craft-fonts}";
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "filmcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mEMNK+uizVpO0szEonWxkK3M6MpGV5s0Blzt9Y5VdAg=";
  };

  cargoHash = "sha256-Ad4aHiGj7dbABxXUIQ9yHnW6q4xuOWnRvm3KC0lu230=";

  cargoBuildFlags = [
    "--package=filmcraft"
    "--package=filmcraft-cli"
    "--features"
    "whisper"
  ];

  # The `filmcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=filmcraft-cli"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.filmcraft";
      desktopName = "FilmCraft";
      genericName = "Video Editor";
      comment = "Edit video, color and sound";
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
      mimeTypes = [
        "application/mxf"
        "application/x-filmcraft"
        "video/3gpp"
        "video/mp2t"
        "video/mp4"
        "video/mpeg"
        "video/quicktime"
        "video/vnd.avi"
        "video/webm"
        "video/x-m4v"
        "video/x-matroska"
        "video/x-msvideo"
      ];
      categories = [
        "AudioVideo"
        "Video"
        "AudioVideoEditing"
      ];
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.filmcraft.mime.xml $out/share/mime/packages/ai.storyteller.filmcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/filmcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Video editing, color and sound, a native Premiere Pro-style editor";
    homepage = "https://github.com/storytold/filmcraft";
    changelog = "https://github.com/storytold/filmcraft/releases/tag/v${finalAttrs.version}";
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
    mainProgram = "filmcraft";
    platforms = rustc.meta.platforms;
  };
})
