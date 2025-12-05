{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  SDL2,
  sdl3,
  useSDL3 ? false,
}:

stdenv.mkDerivation rec {
  pname = "fna3d";
  version = "25.12";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FNA3D";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-nrCBW3UypXUYAt7Ccr3w64QikmN/Vg5TSlQ19/g+anM=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SDL3" useSDL3)
  ];
  buildInputs = if useSDL3 then [ sdl3 ] else [ SDL2 ];
  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Accuracy-focused XNA4 reimplementation for open platforms";
    homepage = "https://fna-xna.github.io/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mrtnvgr ];
  };
}
