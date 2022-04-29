{ lib
, stdenv
, fetchFromGitHub
, cmake
, glib
, libmt32emu
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "mt32emu-smf2wav";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    rev = "mt32emu_smf2wav_${lib.replaceChars [ "." ] [ "_" ] version}";
    hash = "sha256-FnKlKJxe7P4Yqpv0oVGgV4253dMgSmgtb7EAa2FI+aI=";
  };

  postPatch = ''
    sed -i -e '/add_subdirectory(mt32emu)/d' CMakeLists.txt
  '';

  dontFixCmake = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libmt32emu
    glib
  ];

  cmakeFlags = [
    "-Dmunt_WITH_MT32EMU_QT=OFF"
    "-Dmunt_WITH_MT32EMU_SMF2WAV=ON"
  ];

  meta = with lib; {
    homepage = "http://munt.sourceforge.net/";
    description = "Produces a WAVE file from a Standard MIDI file (SMF)";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
    mainProgram = "mt32emu-smf2wav";
  };
}
