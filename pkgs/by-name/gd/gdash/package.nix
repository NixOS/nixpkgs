{
  lib,
  stdenv,
  fetchFromBitbucket,
  pkg-config,
  glib,
  gtk3,
  SDL2_mixer,
  SDL2_image,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdash";
  version = "0-unstable-2023-06-24";

  src = fetchFromBitbucket {
    owner = "czirkoszoltan";
    repo = "gdash";
    rev = "f980da7f4318f5296424720416911876bdb8d6bf";
    hash = "sha256-tYUaWT9cHKgCeu7y0pjHaZ+z4jSr43lAq/jAVE3DSDg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    glib
    gtk3
    SDL2_mixer
    SDL2_image
  ];

  env.NIX_CFLAGS_COMPILE = " -I${SDL2_image}/include/SDL2";

  doCheck = true;

  checkTarget = "check";

  meta = {
    description = "Maze-based puzzle video game, a clone of the original Boulder Dash";
    homepage = "https://bitbucket.org/czirkoszoltan/gdash";
    changelog = "https://bitbucket.org/czirkoszoltan/gdash/src/master/ChangeLog";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
    mainProgram = "gdash";
    platforms = lib.platforms.all;
    # Fails on darwin with:
    # ld: symbol(s) not found for architecture x86_64
    # clang++: error: linker command failed with exit code 1
    broken = stdenv.hostPlatform.isDarwin;
  };
})
