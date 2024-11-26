{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  apple-sdk_11,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moonlight-qt";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = "moonlight-qt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rWVNpfRDLrWsqELPFquA6rW6/AfWV+6DNLUCPqIhle0=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build for Xcode < 14
    (fetchpatch {
      url = "https://github.com/moonlight-stream/moonlight-qt/commit/76deafbd7bf868562d69061e7d6abf2612a2c7ad.patch";
      hash = "sha256-+rXdexZQpOP6yS+oTmvYVxasWxOX16uU1udN75zNX3w=";
    })
  ];

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    pkg-config
    vulkan-headers
  ];

  buildInputs =
    [
      (SDL2.override { drmSupport = stdenv.hostPlatform.isLinux; })
      SDL2_ttf
      ffmpeg
      libopus
      libplacebo
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
      apple-sdk_11
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
