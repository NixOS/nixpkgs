{ lib, stdenv, ladspa-sdk, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "tap-plugins";
  version = "1.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "tomszilagyi";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c6qhyf8smlypc36vmpr42dm3mrzk6pg9cc9r0vx22qbrd5zfpjw";
  };

  buildInputs = [ ladspa-sdk ];

  preInstall = ''
    substituteInPlace Makefile --replace /usr/local "$out"
  '';

  meta = with lib; {
    description = "Tom's Audio Processing plugins";
    longDescription = ''
      A number of LADSPA plugins including: TAP AutoPanner, TAP Chorus/Flanger, TAP DeEsser,
      TAP Dynamics (Mono & Stereo), TAP Equalizer and TAP Equalizer/BW, TAP Fractal Doubler, TAP Pink/Fractal Noise,
      TAP Pitch Shifter, TAP Reflector, TAP Reverberator, TAP Rotary Speaker, TAP Scaling Limiter,
      TAP Sigmoid Booster, TAP Stereo Echo, TAP Tremolo, TAP TubeWarmth, TAP Vibrato.
    '';
    homepage = "https://tap-plugins.sourceforge.net/ladspa.html";
    license = licenses.gpl3;
    maintainers = [ maintainers.fps ];
  };
}
