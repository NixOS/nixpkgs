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
    # The Metal renderer needs FP16 simd support, which is only in the macOS 15+ SDK.
    apple-sdk_15
  ];

  qmakeFlags = [ "CONFIG+=disable-prebuilts" ];

  # Moonlight's QML is compiled into the binary as Qt resources (qrc:/), which
  # qtdeclarative's dont-cache-nix-store-paths.patch doesn't cover. Their disk cache
  # entries look current across versions, so after an update the previous version's
  # QML runs (6.2.0 then hangs at "Starting Desktop..."). Upstream's Flatpak disables
  # the cache too: https://github.com/moonlight-stream/moonlight-qt/issues/2029
  # https://github.com/NixOS/nixpkgs/issues/585085
  qtWrapperArgs = [
    "--set"
    "QML_DISABLE_DISK_CACHE"
    "1"
  ];

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
