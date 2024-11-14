{ lib
, stdenv
, fetchFromSourcehut
, glfw
, libGL
, libGLU
, libsndfile
, openal
, zig_0_11
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackshades";
  version = "2.5.1";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "blackshades";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-qdpXpuXHr9w2XMfgOVveWv3JoqdJHVB8TCqZdyaw/DM=";
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ McSinyx ];
    platforms = lib.platforms.linux;
  };
})
