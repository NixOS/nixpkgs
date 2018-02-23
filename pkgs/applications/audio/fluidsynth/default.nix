{ config, stdenv, lib, fetchFromGitHub, pkgconfig, cmake
, alsaLib, glib, libsndfile
, AudioUnit, CoreAudio, CoreMIDI, CoreServices
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null
, jackSupport ? stdenv.isLinux, libjack2 ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;
assert jackSupport -> libjack2 != null;

stdenv.mkDerivation  rec {
  name = "fluidsynth-${version}";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    rev = "v${version}";
    sha256 = "12q7hv0zvgylsdj1ipssv5zr7ap2y410dxsd63dz22y05fa2hwwd";
  };

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ glib libsndfile ]
    ++ lib.optional  stdenv.isLinux alsaLib
    ++ lib.optional  pulseaudioSupport libpulseaudio
    ++ lib.optional  jackSupport libjack2
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
