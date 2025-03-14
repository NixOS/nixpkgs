{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
  gettext,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  expat,
  glew,
  freetype,
  libSM,
  libXext,
  libGL,
  libGLU,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dreamchess";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "dreamchess";
    repo = "dreamchess";
    rev = "${finalAttrs.version}";
    hash = "sha256-qus/RjwdAl9SuDXfLVKTPImqrvPF3xSDVlbXYLM3JNE=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    expat
    glew
    freetype
    libSM
    libXext
    libGL
    libGLU
    xorg.libxcb
    xorg.libX11
  ];
  nativeBuildInputs = [
    cmake
    bison
    flex
    gettext
  ];
  cmakeFlags = [
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" "GLVND")
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
  ];

  doInstallCheck = true;

  postInstallCheck = ''
    stat "''${!outputBin}/bin/${finalAttrs.meta.mainProgram}"
  '';

  meta = {
    homepage = "https://github.com/dreamchess/dreamchess";
    description = "OpenGL Chess Game";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ spk ];
    platforms = lib.platforms.linux;
    mainProgram = "dreamchess";
  };
})
