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
  version = "0.17.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "effectcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pt4D6BDodgCaTKj11i+/D+RH+B/h/cq8mQgmNIwLhxU=";
  };

  cargoHash = "sha256-86/HTxR+qgkGp3U13fT+b6TGmH44VIvOlMQU+rlyaEc=";

  cargoBuildFlags = [
    "--package=effectcraft"
    "--package=effectcraft-cli"
  ];

  # The `effectcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=effectcraft-cli"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.effectcraft";
      desktopName = "EffectCraft";
      genericName = "Motion Graphics Editor";
      comment = "Motion graphics and visual effects compositor";
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
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/effectcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Motion graphics and visual effects, a native After Effects-style compositor";
    homepage = "https://github.com/storytold/effectcraft";
    changelog = "https://github.com/storytold/effectcraft/releases/tag/v${finalAttrs.version}";
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
    mainProgram = "effectcraft";
    platforms = rustc.meta.platforms;
  };
})
