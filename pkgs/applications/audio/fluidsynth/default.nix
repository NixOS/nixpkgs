{ stdenv, lib, fetchFromGitHub, buildPackages, pkg-config, cmake
, alsa-lib, glib, libjack2, libsndfile, libpulseaudio
, AudioUnit, CoreAudio, CoreMIDI, CoreServices
}:

stdenv.mkDerivation rec {
  pname = "fluidsynth";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    rev = "v${version}";
    sha256 = "sha256-7SuM7a8IIecAJ83QvJfUba/wArAEXywqL2HwVbeG8H4=";
  };

  nativeBuildInputs = [ buildPackages.stdenv.cc pkg-config cmake ];

  buildInputs = [ glib libsndfile libjack2 ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib libpulseaudio ]
    ++ lib.optionals stdenv.isDarwin [ AudioUnit CoreAudio CoreMIDI CoreServices ];

  cmakeFlags = [
    "-Denable-framework=off"
    # set CMAKE_INSTALL_NAME_DIR to correct value on darwin
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage    = "https://www.fluidsynth.org";
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ goibhniu lovek323 ];
    platforms   = platforms.unix;
  };
}
