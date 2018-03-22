{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake
, alsaLib, glib, libjack2, libsndfile, libpulseaudio
, AudioUnit, CoreAudio, CoreMIDI, CoreServices
}:

stdenv.mkDerivation  rec {
  name = "fluidsynth-${version}";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    rev = "v${version}";
    sha256 = "0krvmb1idnf95l2ydzfcb08ayyx3n4m71hf9fgwv3srzaikvpf3q";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ glib libsndfile ]
    ++ lib.optionals (!stdenv.isDarwin) [ alsaLib libpulseaudio libjack2 ]
    ++ lib.optionals stdenv.isDarwin [ AudioUnit CoreAudio CoreMIDI CoreServices ];

  cmakeFlags = lib.optional stdenv.isDarwin "-Denable-framework=off";

  meta = with lib; {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage    = http://www.fluidsynth.org;
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ goibhniu lovek323 ];
    platforms   = platforms.unix;
  };
}
