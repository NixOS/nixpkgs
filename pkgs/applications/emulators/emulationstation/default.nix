{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, curl, boost, eigen
, freeimage, freetype, libGLU, libGL, rapidjson, SDL2, alsa-lib
, vlc }:

stdenv.mkDerivation {
  pname = "emulationstation";
  version = "2.11.2";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "RetroPie";
    repo = "EmulationStation";
    rev = "cda7de687924c4c1ab83d6b0ceb88aa734fe6cfe";
    hash = "sha256-J5h/578FVe4DXJx/AvpRnCIUpqBeFtmvFhUDYH5SErQ=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ alsa-lib boost curl eigen freeimage freetype libGLU libGL rapidjson SDL2 vlc ];

  installPhase = ''
    install -D ../emulationstation $out/bin/emulationstation
    cp -r ../resources/ $out/bin/resources/
  '';

  meta = {
    description = "A flexible emulator front-end supporting keyboardless navigation and custom system themes";
    homepage = "https://emulationstation.org";
    maintainers = [ lib.maintainers.edwtjo ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "emulationstation";
  };
}
