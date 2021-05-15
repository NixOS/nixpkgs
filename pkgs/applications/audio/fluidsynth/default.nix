{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, alsaLib
, glib
, libjack2
, libsndfile
, libpulseaudio
, AudioUnit
, CoreAudio
, CoreMIDI
, CoreServices
}:

let
  generic = version: sha256:
    stdenv.mkDerivation rec {
      pname = "fluidsynth";
      inherit version;

      src = fetchFromGitHub {
        owner = "FluidSynth";
        repo = "fluidsynth";
        rev = "v${version}";
        inherit sha256;
      };

      nativeBuildInputs = [ pkg-config cmake ];

      buildInputs = [ glib libsndfile libpulseaudio libjack2 ]
        ++ lib.optionals stdenv.isLinux [ alsaLib ]
        ++ lib.optionals stdenv.isDarwin [ AudioUnit CoreAudio CoreMIDI CoreServices ];

      cmakeFlags = [ "-Denable-framework=off" ];

      meta = with lib; {
        description = "Real-time software synthesizer based on the SoundFont 2 specifications";
        homepage = "https://www.fluidsynth.org";
        license = licenses.lgpl21Plus;
        maintainers = with maintainers; [ goibhniu lovek323 ];
        platforms = platforms.unix;
      };
    };

in
rec {
  fluidsynth_1 = generic "1.1.11" "sha256-sK1OUBwEzIcYIFiq74iG+hwW3/hdqSmrg4bg1weW5Vg=";
  fluidsynth_2 = generic "2.2.0" "sha256-FT+GhiX5fcTLd8Pk9haaaEoP3aoXNf+V82lDwSdWyZw=";
  fluidsynth = fluidsynth_2;
}
