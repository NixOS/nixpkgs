{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gitMinimal,
  shaderc,
  wayland-scanner,
  boost,
  curl,
  ffmpeg-headless,
  libpng,
  openssl,
  libx11,
  libxrender,
  libdecor,
  libxkbcommon,
  wayland,
  wayland-protocols,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "infinidream";
  version = "0.16.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "e-dream-ai";
    repo = "client";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-HfztvWByKt4L1m2pZWSRz7Md+nvQR6P/YmvfdM+MqIU=";
  };

  sourceRoot = "${finalAttrs.src.name}/client_generic/LinuxBuild";

  nativeBuildInputs = [
    cmake
    pkg-config
    gitMinimal
    shaderc
    wayland-scanner
  ];

  buildInputs = [
    boost
    curl
    ffmpeg-headless
    libpng
    openssl

    libx11
    libxrender

    libdecor
    libxkbcommon
    wayland
    wayland-protocols
    vulkan-headers
    vulkan-loader
  ];

  cmakeFlags = [
    "-DAPP_VERSION=${finalAttrs.version}"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 infinidream "$out/bin/infinidream"

    if [ -d shaders ]; then
      cp -r shaders "$out/bin/shaders"
    fi

    if [ -f BuildData.json ]; then
      install -Dm644 BuildData.json "$out/bin/BuildData.json"
    fi

    install -Dm644 \
      ../infinidream.desktop \
      "$out/share/applications/infinidream.desktop"

    runHook postInstall
  '';

  meta = {
    description = "Generative visual screensaver, originally Electric Sheep";
    homepage = "https://infinidream.ai/";
    changelog = "https://github.com/e-dream-ai/client/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    mainProgram = "infinidream";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      mikecm
    ];
  };
})
