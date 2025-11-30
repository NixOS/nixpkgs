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
  version = "25.11";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FNA3D";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-4+bJWmNagUtKJJHIHefQM7Tiu39+l4OE9q51c34DiEk=";
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
