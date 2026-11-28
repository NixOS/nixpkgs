{ lib
, fetchFromGitHub
, stdenv
, cmake
, fluidsynth
, glew
, gnome
, libX11
, libXrandr
, libXinerama
, libXext
, SDL2
}:

stdenv.mkDerivation(finalAttrs:{
  pname = "relive";
  version = "1.0.4687";

  src = fetchFromGitHub {
    owner = "AliveTeam";
    repo = "alive_reversing";
    rev = "appveyor_${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-4dZ4efxqdK/MJauQwQVBiz/AeqeCnEDNYwOKbDzU1gY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    fluidsynth
    glew
    libX11
    libXrandr
    libXinerama
    libXext
    SDL2
    gnome.zenity
  ];

  meta = with lib;{
    description = "Re-implementation of Oddworld: Abe's Exoddus and Oddworld: Abe's Oddysee ";
    homepage = "https://github.com/AliveTeam/alive_reversing";
    maintainers = with maintainers; [ ByteSudoer ];
    license = licenses.mit;
    mainProgram = "relive";
  };
})
