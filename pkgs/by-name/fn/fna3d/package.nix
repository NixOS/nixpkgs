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
<<<<<<< HEAD
  version = "25.12";
=======
  version = "25.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FNA3D";
    tag = version;
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-nrCBW3UypXUYAt7Ccr3w64QikmN/Vg5TSlQ19/g+anM=";
=======
    hash = "sha256-4+bJWmNagUtKJJHIHefQM7Tiu39+l4OE9q51c34DiEk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
