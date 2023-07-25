{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, SDL2
, SDL2_image
, SDL2_ttf
, alsa-lib
, freetype
, glew
, libGL
, libogg
, libpng
, libtheora
, libvorbis
, python3
, tcl
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openmsx";
  version = "18.0";

  src = fetchFromGitHub {
    owner = "openMSX";
    repo = "openMSX";
    rev = "RELEASE_${builtins.replaceStrings ["."] ["_"] finalAttrs.version}";
    sha256 = "sha256-4V2B+OQbPVRmkRuqfeqyd+7pz9Z1YISjI79WqZS0Qhc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    alsa-lib
    freetype
    glew
    libGL
    libogg
    libpng
    libtheora
    libvorbis
    tcl
    zlib
  ];

  postPatch = ''
    cp ${./custom-nix.mk} build/custom.mk
  '';

  dontAddPrefix = true;

  # Many thanks @mthuurne from OpenMSX project for providing support to
  # Nixpkgs! :)
  TCL_CONFIG="${tcl}/lib/";

  meta = with lib; {
    homepage = "https://openmsx.org";
    description = "The MSX emulator that aims for perfection";
    longDescription = ''
      OpenMSX is an emulator for the MSX home computer system. Its goal is
      to emulate all aspects of the MSX with 100% accuracy.
    '';
    license = with licenses; [ bsd2 boost gpl2Plus ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
