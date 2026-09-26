{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeWrapper,
  alsa-lib,
  ffmpeg,
  fontconfig,
  freetype,
  libdrm,
  libGL,
  libx11,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:

let
  cargoFlags = [
    "--package"
    "frame-app"
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "frame-media-converter";
  version = "0.31.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "66HEX";
    repo = "frame";
    tag = finalAttrs.version;
    hash = "sha256-QBwwa5z0BbNa0p7MbV2J+K+NOe0cFxXq9LyvalKTMFY=";
  };

  cargoHash = "sha256-HJZEY4noPypIXHB6ZMtPKuBawaMmmEpVbfo44v6tKws=";
  cargoBuildFlags = cargoFlags;
  cargoTestFlags = cargoFlags;

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
    vulkan-loader
    wayland
  ];

  postInstall = ''
    install -Dm444 frame-app/resources/frame.desktop.in \
      $out/share/applications/frame.desktop
    substituteInPlace $out/share/applications/frame.desktop \
      --replace-fail '$APP_NAME' Frame \
      --replace-fail '$APP_CLI' frame \
      --replace-fail '$APP_ICON' frame

    for icon in \
      32:32x32.png \
      64:64x64.png \
      128:128x128.png \
      256:128x128@2x.png \
      512:icon.png
    do
      size="''${icon%%:*}"
      file="''${icon#*:}"
      install -Dm444 "frame-app/resources/app-icons/$file" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/frame.png"
    done
  '';

  postFixup = ''
    patchelf $out/bin/frame --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
      ]
    }

    wrapProgram $out/bin/frame \
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
    mainProgram = "frame";
    maintainers = [ lib.maintainers._66HEX ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
