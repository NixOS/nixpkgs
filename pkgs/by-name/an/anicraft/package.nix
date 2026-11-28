{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
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
    libxrandr
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anicraft";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "anicraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2y6pbiUS4h4+qgGw5xA23uHGU4/hdQpjXIhv/xetbBI=";
  };

  cargoHash = "sha256-WOPOpQGGAlxPV1C9WsqVOeqxnW34/gGAX5v1OlCHGpY=";

  cargoBuildFlags = [
    "--package=anicraft"
  ];

  cargoTestFlags = [
    "--package=anicraft"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  # cpal (feature `sound-output`) links ALSA on Linux — see Cargo.toml.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  # v0.2.1: pseudo-locale coverage tests still list many untranslated controls (upstream).
  checkFlags = [
    "--skip=every_control_can_be_used_in_the_pseudo_locale"
    "--skip=screen_reader_names_are_translated_too"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.anicraft.desktop \
      $out/share/applications/ai.storyteller.anicraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.anicraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.anicraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/anicraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "2D vector animation editor with a timeline";
    homepage = "https://github.com/storytold/AniCraft";
    changelog = "https://github.com/storytold/anicraft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "anicraft";
  };
})
