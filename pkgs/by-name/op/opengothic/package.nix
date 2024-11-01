{
  alsa-lib,
  cmake,
  fetchFromGitHub,
  glslang,
  lib,
  libX11,
  libXcursor,
  libglvnd,
  makeWrapper,
  ninja,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  vulkan-validation-layers,
}:
stdenv.mkDerivation {
  pname = "opengothic";
  version = "0.80-unstable-09-10-2024";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "0db60b0a956e2a2f365aa3a8bdbe366be198e641";
    fetchSubmodules = true;
    hash = "sha256-Hf3B7B4CaW/GsTcYs0PChpPfA9aK41pPJkImtUDgoKc=";
  };

  outputs = [
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    glslang
    makeWrapper
    ninja
  ];

  buildInputs = [
    alsa-lib
    libX11
    libXcursor
    libglvnd
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
  ];

  postFixup = ''
    wrapProgram $out/bin/Gothic2Notr \
      --set LD_PRELOAD "${lib.getLib alsa-lib}/lib/libasound.so.2"
  '';

  meta = {
    description = "Open source re-implementation of Gothic 2: Night of the Raven";
    homepage = "https://github.com/Try/OpenGothic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.linux;
    mainProgram = "Gothic2Notr";
  };
}
