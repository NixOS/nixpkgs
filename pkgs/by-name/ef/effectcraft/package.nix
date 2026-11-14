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
  version = "0.24.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "effectcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dtqPop1xmtd/duzJt02QCZj5zrtVtyvUI8hj4TbeSkc=";
  };

  cargoHash = "sha256-TyxQTE247lH2Q1vUJQZudrYSHx7DS+DF5ZfbUUpB/XI=";

  cargoBuildFlags = [
    "--package=effectcraft"
    "--package=effectcraft-cli"
  ];

  # The effectcraft crate runs live GPU tests.
  cargoTestFlags = [
    "--package=effectcraft-cli"
  ];

  # Unused egui fork entries break cargo --offline.
  # Leave egui_extras: it is a real workspace.dependencies entry.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
    substituteInPlace apps/effectcraft/src/main.rs \
      --replace-fail 'control_port.is_none()' 'false'
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  postInstall = ''
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
    install -Dm644 packaging/linux/ai.storyteller.effectcraft.desktop \
      $out/share/applications/ai.storyteller.effectcraft.desktop
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/ai.storyteller.effectcraft.mime.xml \
      $out/share/mime/packages/ai.storyteller.effectcraft.xml
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
    changelog = "https://github.com/storytold/effectcraft/releases/tag/${finalAttrs.src.tag}";
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
  };
})
