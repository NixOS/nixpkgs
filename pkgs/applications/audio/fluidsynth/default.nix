{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake
, alsaLib, glib, libjack2, libsndfile, libpulseaudio
, AudioUnit, CoreAudio, CoreMIDI, CoreServices
, version ? "2"
}:

let
  versionMap = {
    "1" = {
      fluidsynthVersion = "1.1.11";
      sha256 = "0n75jq3xgq46hfmjkaaxz3gic77shs4fzajq40c8gk043i84xbdh";
    };
    "2" = {
      fluidsynthVersion = "2.0.6";
      sha256 = "0nas9pp9r8rnziznxm65x2yzf1ryg98zr3946g0br3s38sjf8l3a";
    };
  };
in

with versionMap.${version};

stdenv.mkDerivation  {
  name = "fluidsynth-${fluidsynthVersion}";
  version = fluidsynthVersion;

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    rev = "v${fluidsynthVersion}";
    inherit sha256;
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ glib libsndfile libpulseaudio libjack2 ]
    ++ lib.optionals stdenv.isLinux [ alsaLib ]
    ++ lib.optionals stdenv.isDarwin [ AudioUnit CoreAudio CoreMIDI CoreServices ];

  cmakeFlags = [ "-Denable-framework=off" ];

  meta = with lib; {
    description = "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage    = http://www.fluidsynth.org;
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ goibhniu lovek323 ];
    platforms   = platforms.unix;
  };
}
