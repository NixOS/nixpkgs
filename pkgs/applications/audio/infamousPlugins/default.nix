{ stdenv, fetchFromGitHub, pkgconfig, cairomm, cmake, lv2, libpthreadstubs, libXdmcp, libXft, ntk, pcre, fftwFloat, zita-resampler }:

stdenv.mkDerivation rec {
  name = "infamousPlugins-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ssj71";
    repo = "infamousPlugins";
    rev = "v${version}";
    sha256 = "1r72agk5nxf5k0mghcc2j90z43j5d9i7rqjmf49jfyqnd443isip";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ cairomm lv2 libpthreadstubs libXdmcp libXft ntk pcre fftwFloat zita-resampler ];

  meta = with stdenv.lib; {
    homepage = https://ssj71.github.io/infamousPlugins;
    description = "A collection of open-source LV2 plugins";
    longDescription = ''
      These are audio plugins in the LV2 format, developed for linux. Most are suitable for live use.
      This collection contains:
        * Cellular Automaton Synth - additive synthesizer, where 16 harmonics are added according to rules of elementary cellular automata
        * Envelope Follower - a fully featured envelope follower plugin
        * Hip2B - a distortion/destroyer plugin
        * cheap distortion - another distortion plugin, but this one I wanted to get it as light as possible
        * stuck - a clone of the electro-harmonix freeze
        * power cut - this effect is commonly called tape stop
        * power up - the opposite of the power cut
        * ewham - a whammy style pitchshifter
        * lushlife - a simulated double tracking plugin capable of everything from a thin beatle effect to thick lush choruses to weird outlandish effects
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
