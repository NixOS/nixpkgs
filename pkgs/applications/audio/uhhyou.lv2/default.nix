{ lib, stdenv
, fetchFromGitHub
, pkg-config
, python3
, fftw
, libGL
, libX11
, libjack2
, liblo
, lv2
}:

stdenv.mkDerivation rec {
  # this is what upstream calls the package, see:
  # https://github.com/ryukau/LV2Plugins#uhhyou-plugins-lv2
  pname = "uhhyou.lv2";
  version = "unstable-2021-02-08";

  src = fetchFromGitHub {
    owner = "ryukau";
    repo =  "LV2Plugins";
    rev = "df67460fc344f94db4306d4ee21e4207e657bbee";
    fetchSubmodules = true;
    sha256 = "1a23av35cw26zgq93yzmmw35084hsj29cb7sb04j2silv5qisila";
  };

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ fftw libGL libX11 libjack2 liblo lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  prePatch = ''
    patchShebangs generate-ttl.sh patch.sh patch/apply.sh
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Audio plugins for Linux";
    longDescription = ''
      Plugin List:
      - CollidingCombSynth
      - CubicPadSynth
      - EnvelopedSine
      - EsPhaser
      - FDNCymbal
      - FoldShaper
      - IterativeSinCluster
      - L3Reverb
      - L4Reverb
      - LatticeReverb
      - LightPadSynth
      - ModuloShaper
      - OddPowShaper
      - SevenDelay
      - SoftClipper
      - SyncSawSynth
      - TrapezoidSynth
      - WaveCymbal
    '';
    homepage = "https://github.com/ryukau/LV2Plugins/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
