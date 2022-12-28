{ lib
, stdenv
, fetchFromGitHub
, cmake
, glib
, libmt32emu
, pkg-config
}:

let
  char2underscore = char: str: lib.replaceStrings [ char ] [ "_" ] str;
in
stdenv.mkDerivation rec {
  pname = "mt32emu-smf2wav";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    rev = "${char2underscore "-" pname}_${char2underscore "." version}";
    sha256 = "sha256-XGds9lDfSiY0D8RhYG4TGyjYEVvVYuAfNSv9+VxiJEs=";
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
  };
}
