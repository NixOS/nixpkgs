{
  alsa-lib,
  fetchFromGitHub,
  ffmpeg,
  fontconfig,
  freetype,
  lib,
  libdrm,
  libGL,
  libx11,
  libxcb,
  libxkbcommon,
  makeWrapper,
  pkg-config,
  rustPlatform,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "frame-media-converter";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "66HEX";
    repo = "frame";
    tag = finalAttrs.version;
    hash = "sha256-2BT4+7C1f2laflMvUMC35/F0mYF/j/0PO8XjaLDTjqY=";
  };

  cargoHash = "sha256-7cmLjjkaVraLtcI0JmMEbiH9gMUUe+zA+6HMQ2AHd7w=";

  cargoBuildFlags = [
    "--package"
    "frame-app"
  ];

  cargoTestFlags = [
    "--package"
    "frame-app"
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    libdrm
    libGL
    libx11
    libxcb
    libxkbcommon
    wayland
  ];

  postInstall = ''
    install -Dm444 frame-app/resources/frame.desktop.in "$out/share/applications/frame.desktop"
    substituteInPlace "$out/share/applications/frame.desktop" \
      --replace-fail '$APP_NAME' Frame \
      --replace-fail '$APP_CLI' frame \
      --replace-fail '$APP_ICON' frame

    install -Dm444 frame-app/resources/app-icons/32x32.png \
      "$out/share/icons/hicolor/32x32/apps/frame.png"
    install -Dm444 frame-app/resources/app-icons/64x64.png \
      "$out/share/icons/hicolor/64x64/apps/frame.png"
    install -Dm444 frame-app/resources/app-icons/128x128.png \
      "$out/share/icons/hicolor/128x128/apps/frame.png"
    install -Dm444 frame-app/resources/app-icons/128x128@2x.png \
      "$out/share/icons/hicolor/256x256/apps/frame.png"
    install -Dm444 frame-app/resources/app-icons/icon.png \
      "$out/share/icons/hicolor/512x512/apps/frame.png"
  '';

  postFixup = ''
    wrapProgram "$out/bin/frame" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]} \
      --set FRAME_USE_SYSTEM_MEDIA_TOOLS 1 \
      --set FRAME_UPDATE_EXPLANATION \
        'This Nixpkgs build is managed by Nix. Install updates through your Nix profile, flake, or NixOS configuration.'
  '';

  meta = {
    description = "Native desktop interface for FFmpeg media conversion";
    homepage = "https://github.com/66HEX/frame";
    changelog = "https://github.com/66HEX/frame/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers._66HEX ];
    mainProgram = "frame";
    platforms = [ "x86_64-linux" ];
  };
})
