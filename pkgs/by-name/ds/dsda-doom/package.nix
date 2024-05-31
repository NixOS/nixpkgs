{ lib
, stdenv
, fetchFromGitHub
, cmake
, SDL2
, SDL2_mixer
, SDL2_image
, fluidsynth
, soundfont-fluid
, portmidi
, dumb
, libvorbis
, libmad
, libGLU
, libzip
}:

stdenv.mkDerivation rec {
  pname = "dsda-doom";
  version = "0.27.5";

  src = fetchFromGitHub {
    owner = "kraflab";
    repo = "dsda-doom";
    rev = "v${version}";
    hash = "sha256-+rvRj6RbJ/RaKmlDZdB2oBm/U6SuHNxye8TdpEOZwQw=";
  };

  sourceRoot = "${src.name}/prboom2";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_image
    fluidsynth
    portmidi
    dumb
    libvorbis
    libmad
    libGLU
    libzip
  ];

  # Fixes impure path to soundfont
  prePatch = ''
    substituteInPlace src/m_misc.c --replace \
      "/usr/share/sounds/sf3/default-GM.sf3" \
      "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"
  '';

  meta = with lib; {
    homepage = "https://github.com/kraflab/dsda-doom";
    description = "An advanced Doom source port with a focus on speedrunning, successor of PrBoom+";
    mainProgram = "dsda-doom";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.Gliczy ];
  };
}
