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

  postPatch =
    # Make sure system-installed libmt32emu is used
    # Don't depend on in-tree mt32emu to be used
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(mt32emu)' "" \
        --replace-fail 'add_dependencies(mt32emu-smf2wav mt32emu)' ""
    ''
    # Bump CMake minimum to something our CMake supports
    # Fixed treewide in https://github.com/munt/munt/commit/e6af0c7e5d63680716ab350467207c938054a0df
    # Remove when version > 1.9.0
    + ''
      substituteInPlace {./,mt32emu_smf2wav/,mt32emu_smf2wav/libsmf/}CMakeLists.txt \
        --replace-fail 'cmake_minimum_required(VERSION 2.8.12)' 'cmake_minimum_required(VERSION 2.8.12...3.27)'
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
    (lib.cmakeBool "munt_WITH_MT32EMU_QT" false)
    (lib.cmakeBool "munt_WITH_MT32EMU_SMF2WAV" true)
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
