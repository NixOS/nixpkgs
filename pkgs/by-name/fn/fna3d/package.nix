{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  sdl3,
  useSDL3 ? false,
}:

stdenv.mkDerivation rec {
  pname = "fna3d";
  version = "25.10";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FNA3D";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-Hbj1GGKSFaP2C7V0II6x6euxRDc/BYSK00cVsFMKGEw=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SDL3" useSDL3)
  ];
  buildInputs = if useSDL3 then [ sdl3 ] else [ SDL2 ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Accuracy-focused XNA4 reimplementation for open platforms";
    homepage = "https://fna-xna.github.io/";
    license = lib.licenses.mspl;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mrtnvgr ];
  };
}
