{
  lib,
  stdenv,
  rustPlatform,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  desktopToDarwinBundle,
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
  version = "0.20.1";

  __structuredAttrs = true;

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "filmcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-efnUlfnS56t760z0hwQHGUtp4x7zzKnW6BJkyWwa1RQ=";
  };

  cargoHash = "sha256-aQnPf3S3Mx/TsMNdbms2C2ACc4Zitggvw3PWcLEEZuI=";

  cargoBuildFlags = [
    "--package=filmcraft"
    "--package=filmcraft-cli"
    "--features"
    "whisper"
  ];

  # The filmcraft crate runs live GPU tests.
  cargoTestFlags = [
    "--package=filmcraft-cli"
  ];

  # Unused egui fork entries break cargo --offline.
  # Leave egui_extras: it is a real workspace.dependencies entry.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
    substituteInPlace apps/filmcraft/src/main.rs \
      --replace-fail 'app.set_startup_update_check(true);' 'app.set_startup_update_check(false);'
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  postInstall = ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
    install -Dm644 packaging/linux/ai.storyteller.filmcraft.desktop \
      $out/share/applications/ai.storyteller.filmcraft.desktop
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.filmcraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.filmcraft.xml
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
    changelog = "https://github.com/storytold/filmcraft/releases/tag/${finalAttrs.src.tag}";
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
  };
})
