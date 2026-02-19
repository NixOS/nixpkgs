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

stdenv.mkDerivation (finalAttrs: {
  pname = "fna3d";
  version = "26.02";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FNA3D";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-Gwuml5ZR3m7PEqfYz/BySN9/lsb5Rbej9v0fMfUxt/I=";
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
})
