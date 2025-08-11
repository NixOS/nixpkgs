{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  sdl3,
  libpulseaudio,
  pipewire,
  fftwFloat,
  freetype,
  glew,
  libGL,
  yaml-cpp,
  libebur128,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pulse-visualizer";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Beacroxx";
    repo = "pulse-visualizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e/UDg+BM9ly6iK8AlBBkAyE7OFL7ksNzjeAuyEGgsPk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    sdl3
    libpulseaudio
    pipewire
    fftwFloat
    freetype
    glew
    libGL
    yaml-cpp
    libebur128
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail " -march=native" "" \
      --replace-fail " -mtune=native" "" \
      --replace-fail "-Wl,-s" "" \
      --replace-fail " -s" "" \
      --replace-fail 'set(CMAKE_INSTALL_PREFIX "/usr" CACHE PATH "Installation prefix" FORCE)' ""
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = {
    description = "Real-time audio visualizer inspired by MiniMeters";
    homepage = "https://github.com/Beacroxx/pulse-visualizer";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ miyu ];
    platforms = lib.platforms.x86_64;
    badPlatforms = lib.platforms.darwin;
  };
})
