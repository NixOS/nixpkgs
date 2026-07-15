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
    sha256 = "0jywsrcr1wzkjig5cvz014c3r026sbwscbkv7zh1014lkjm0kyyh";
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
