{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6,
  pkg-config,
  vulkan-headers,
  SDL2,
  SDL2_ttf,
  ffmpeg,
  libopus,
  libplacebo,
  openssl,
  alsa-lib,
  libpulseaudio,
  libva,
  libvdpau,
  libxkbcommon,
  wayland,
  libdrm,
  apple-sdk_15,
  nix-update-script,
}:

let
  # Moonlight-qt 6.2.0's MoltenVK renderer requires libplacebo's scRGB support,
  # which is not in any release yet.
  # Reuse the same libplacebo revision as upstream's macOS builds, see
  # https://github.com/moonlight-stream/moonlight-qt-deps
  # Remove this override once libplacebo provides PL_COLOR_TRC_SCRGB.
  libplacebo' =
    if stdenv.hostPlatform.isDarwin then
      libplacebo.overrideAttrs (prev: {
        version = "7.360.1-unstable-2026-10-01";
        src = prev.src.override {
          tag = null;
          rev = "92b5ac6db79f4d680eb656692f7bf51e9606f42a";
          hash = "sha256-cYX2Hn7I8zWz7yvHyvmlpC+YmoCMqD7ZJQktYp9MJhM=";
        };
      })
    else
      libplacebo;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "moonlight-qt";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = "moonlight-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s6b3L51jCNuYJS0dvx2tkNvzNzrsSzzdSfTgM+IR1kg=";
    fetchSubmodules = true;
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    # nixpkgs' ffmpeg on darwin is built without Vulkan, so it lacks
    # av_vk_get_optional_device_extensions(). Use the static extension list.
    ./darwin-no-ffmpeg-vulkan.patch
  ];

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    pkg-config
    vulkan-headers
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    ffmpeg
    libopus
    libplacebo'
    qt6.qtdeclarative
    qt6.qtsvg
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
    libva
    libvdpau
    libxkbcommon
    qt6.qtwayland
    wayland
    libdrm
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # The Metal renderer needs FP16 simd support, which is only in the macOS 15+ SDK.
    apple-sdk_15
  ];

  qmakeFlags = [ "CONFIG+=disable-prebuilts" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications $out/bin
    mv app/Moonlight.app $out/Applications
    ln -s $out/Applications/Moonlight.app/Contents/MacOS/Moonlight $out/bin/moonlight
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/moonlight-stream/moonlight-qt/releases/tag/v${finalAttrs.version}";
    description = "Play your PC games on almost any device";
    homepage = "https://moonlight-stream.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      azuwis
      zmitchell
    ];
    platforms = lib.platforms.all;
    mainProgram = "moonlight";
  };
})
