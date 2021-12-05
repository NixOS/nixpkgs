{ stdenv, lib, fetchFromGitHub, buildPackages, pkg-config, cmake, alsa-lib, glib
, libjack2, libsndfile, libpulseaudio, AudioUnit, CoreAudio, CoreMIDI
, CoreServices }:

stdenv.mkDerivation rec {
  pname = "fluidsynth";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "FluidSynth";
    repo = "fluidsynth";
    rev = "v${version}";
    sha256 = "0x5808d03ym23np17nl8gfbkx3c4y3d7jyyr2222wn2prswbb6x3";
  };

  nativeBuildInputs = [ buildPackages.stdenv.cc pkg-config cmake ];

  buildInputs = [ glib libsndfile libpulseaudio libjack2 ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.isDarwin [
      AudioUnit
      CoreAudio
      CoreMIDI
      CoreServices
    ];

  cmakeFlags = [ "-Denable-framework=off" ];

  meta = with lib; {
    description =
      "Real-time software synthesizer based on the SoundFont 2 specifications";
    homepage = "https://www.fluidsynth.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ goibhniu lovek323 ];
    platforms = platforms.unix;
  };
}
