{
  lib,
  stdenv,
  fetchFromSourcehut,
  glfw,
  libGL,
  libGLU,
  libsndfile,
  openal,
  zig_0_14,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackshades";
  version = "2.5.2-unstable-2025-03-12";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "blackshades";
    rev = "a2fbe0e08bedbbbb1089dbb8f3e3cb4d76917bd0";
    fetchSubmodules = true;
    hash = "sha256-W6ltmWCw7jfiTiNlh60YVF7mz//8s+bgu4F9gy5cDgw=";
  };

  postUnpack = ''
    ln -s ${
      zig_0_14.fetchDeps {
        inherit (finalAttrs)
          src
          pname
          version
          ;
        hash = "sha256-wBIfLeaKtTow2Z7gjEgIFmqcTGWgpRWI+k0t294BslM=";
      }
    } $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [ zig_0_14.hook ];

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
