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
      fluidsynthVersion = "2.0.3";
      sha256 = "00f6bhw4ddrinb5flvg5y53rcvnf4km23a6nbvnswmpq13568v78";
    };
  };
in

with versionMap.${version};

stdenv.mkDerivation  rec {
  name = "fluidsynth-${fluidsynthVersion}";
  version = fluidsynthVersion;

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    rev = "v${fluidsynthVersion}";
    inherit sha256;
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
