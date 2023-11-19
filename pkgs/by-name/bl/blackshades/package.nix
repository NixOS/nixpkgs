{
  lib,
  stdenv,
  fetchFromSourcehut,
  glfw,
  libGL,
  libGLU,
  libsndfile,
  openal,
  zig_0_11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackshades";
  version = "2.5.2";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "blackshades";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-K/OFL49hXAzeEU1pfpxrIF7NgFfRk11Ah1OHKN8Ulb0=";
  };

  nativeBuildInputs = [ zig_0_11.hook ];

  buildInputs = [
    glfw
    libGLU
    libGL
    libsndfile
    openal
  ];

  meta = {
    homepage = "https://sr.ht/~cnx/blackshades";
    description = "Psychic bodyguard FPS";
    changelog = "https://git.sr.ht/~cnx/blackshades/refs/${finalAttrs.version}";
    mainProgram = "blackshades";
    license = with lib.licenses; [ gpl3Plus cc-by-30 cc-by-sa-30 cc-by-40 ];
    maintainers = with lib.maintainers; [ McSinyx ];
    platforms = lib.platforms.linux;
  };
})
