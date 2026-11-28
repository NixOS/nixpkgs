{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  lib,
  libGL,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  nix-update-script,
  pkg-config,
  python3,
  rustPlatform,
  vulkan-loader,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openrb-338";
  version = "2026.1126.0917";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pingw33n";
    repo = "OpenRB-338";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qg6RY7fMw8o5YaGkosXo6Xm8XHEZOcoBr8WrIZkpSx4=";
  };

  cargoHash = "sha256-YsZXbaRVJJSF5nYyJsXkGy3w+eFBYkeMKpvrlN9DOjA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libGL
    wayland
    vulkan-loader
    dbus
  ];

  # Some tests need a Python on PATH
  nativeCheckInputs = [
    python3
  ];

  preCheck = ''
    cp -p target/*-*/release/liborb_plugin.so target/release/
  '';

  postInstall = ''
    rm $out/bin/ui-art # developer icon-rendering tool, not a user command
    rm $out/bin/xtask # developer task runner

    mkdir -p $out/share/applications
    substitute scripts/OpenRB-338.desktop.in $out/share/applications/OpenRB-338.desktop \
      --replace-fail '@EXEC@' 'OpenRB-338' \
      --replace-fail '@ICON@' 'OpenRB-338'

    install -Dm644 assets/ui/app_icon.svg $out/share/icons/hicolor/scalable/apps/OpenRB-338.svg
  '';

  postFixup = ''
    patchelf --set-rpath "${
      lib.makeLibraryPath [
        alsa-lib
        libx11
        libxcb
        libxcursor
        libxi
        libxkbcommon
        libGL
        wayland
        vulkan-loader
        dbus
      ]
    }" $out/bin/OpenRB-338
  '';

  # Neither binary implements --version, so smoke-test the help paths instead
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/OpenRB-338" --help > /dev/null
    "$out/bin/orb" --help > /dev/null
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ReBirth RB-338 reimplementation";
    homepage = "https://github.com/pingw33n/OpenRB-338";
    changelog = "https://github.com/pingw33n/OpenRB-338/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Only
      ofl
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "OpenRB-338";
    platforms = lib.platforms.linux;
  };
})
