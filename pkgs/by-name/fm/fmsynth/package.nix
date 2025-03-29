{
  lib,
  stdenv,
  fetchFromGitHub,
  gtkmm2,
  lv2,
  lvtk,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "fmsynth-unstable";
  version = "2015-02-07";
  src = fetchFromGitHub {
    owner = "Themaister";
    repo = "libfmsynth";
    rev = "9ffa1d2fea287f1209b210d2dbde2f0f60f37176";
    sha256 = "1bk0bpr069hzx2508rgfbwpxiqgr7dmdkhqdywmd2i4rmibgrm1q";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtkmm2
    lv2
    lvtk
  ];

  buildPhase = ''
    cd lv2
    substituteInPlace GNUmakefile --replace "/usr/lib/lv2" "$out/lib/lv2"
    make  SIMD=0
  '';

  preInstall = "mkdir -p $out/lib/lv2";

  meta = {
    description = "Flexible 8 operator FM synthesizer for LV2";
    longDescription = ''
      The synth core supports:

      - Arbitrary amounts of polyphony
      - 8 operators
      - No fixed "algorithms"
      - Arbitrary modulation, every operator can modulate any other operator, even itself
      - Arbitrary carrier selection, every operator can be a carrier
      - Sine LFO, separate LFO per voice, modulates amplitude and frequency of operators
      - Envelope per operator
      - Carrier stereo panning
      - Velocity sensitivity per operator
      - Mod wheel sensitivity per operator
      - Pitch bend
      - Keyboard scaling
      - Sustain, sustained keys can overlap each other for a very rich sound
      - Full floating point implementation optimized for SIMD
      - Hard real-time constraints
    '';
    homepage = "https://github.com/Themaister/libfmsynth";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
