{
  lib,
  mkHyprlandPlugin,
  fetchFromGitHub,
  cmake,
  curl,
  ffmpeg,
  fftw,
  glib,
  hyprland,
  icu,
  kdePackages,
  libpulseaudio,
  lua5_4,
  nlohmann_json,
  opencv,
  openssl,
  pipewire,
  python3,
  wayland,
  wayland-protocols,
}:

mkHyprlandPlugin (finalAttrs: {
  pluginName = "hyprcapture";
  version = "0.6.0-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "HyprCapture";
    rev = "7ebc3f36f782d7b62ad7f20906f7c921aa27231f";
    hash = "sha256-644DnXYqaGVX+PUT2dwOD8gROHZt7GGoFDANwCUGMcA=";
  };

  nativeBuildInputs = [
    cmake
    python3
    wayland
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg
    fftw
    glib
    icu
    kdePackages.layer-shell-qt
    kdePackages.qtbase
    kdePackages.qtsvg
    libpulseaudio
    lua5_4
    nlohmann_json
    opencv
    openssl
    pipewire
    wayland
    wayland-protocols
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "HYPRCAPTURE_GAINMAP_HEIC" false)
    (lib.cmakeFeature "HYPRCAPTURE_DEFAULT_HELPER_PATH" "${placeholder "out"}/bin/hyprcapture-ui")
    (lib.cmakeFeature "HYPRCAPTURE_TRUSTED_BIN_DIRS" "${lib.makeBinPath [
      hyprland
      ffmpeg
      curl
    ]}")
  ];

  postInstall = ''
    test -x "$out/bin/hyprcapture-shot"
    test -x "$out/bin/hyprcapture-ocr"
  '';

  meta = {
    description = "Hyprland-only screenshot and recording tool";
    homepage = "https://github.com/gfhdhytghd/HyprCapture";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ cRolandoJr ];
    platforms = hyprland.meta.platforms;
    mainProgram = "hyprcapture-ui";
  };
})
