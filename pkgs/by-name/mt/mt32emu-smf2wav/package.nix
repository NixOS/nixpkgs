{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  libmt32emu,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mt32emu-smf2wav";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "munt";
    repo = "munt";
    rev = "mt32emu_smf2wav_${lib.replaceString "." "_" finalAttrs.version}";
    sha256 = "sha256-XGds9lDfSiY0D8RhYG4TGyjYEVvVYuAfNSv9+VxiJEs=";
  };

  postPatch = ''
    sed -i -e '/add_subdirectory(mt32emu)/d' CMakeLists.txt
    # This directly resolves the 'The dependency target "mt32emu" ... does not exist' error.
    sed -i -e '/add_dependencies(mt32emu-smf2wav mt32emu)/d' CMakeLists.txt

    substituteInPlace {./,mt32emu_smf2wav/,mt32emu_smf2wav/libsmf/}CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"
  '';

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

  meta = {
    homepage = "https://munt.sourceforge.net/";
    description = "Produces a WAVE file from a Standard MIDI file (SMF)";
    mainProgram = "mt32emu-smf2wav";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
})
