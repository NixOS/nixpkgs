{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libglut,
  libGL,
  libGLU,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdaps-gl";
  version = "0.0.7";
  src = fetchFromGitHub {
    owner = "linux-thinkpad";
    repo = "hdaps-gl";
    rev = finalAttrs.version;
    hash = "sha256-0PsJqpyUBBDgP3supvnSRoA8GAngb1ZelPPzkFnW3Es=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    libglut
    libGL
    libGLU
  ];

  meta = {
    description = "GL-based laptop model that rotates in real-time via hdaps";
    homepage = "https://github.com/linux-thinkpad/hdaps-gl";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.symphorien ];
    mainProgram = "hdaps-gl";
  };
})
