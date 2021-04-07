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
  version = "unstable-2020-07-31";

  src = fetchFromGitHub {
    owner = "ryukau";
    repo =  "LV2Plugins";
    rev = "6189be67acaeb95452f8adab73a731d94a7b6f47";
    fetchSubmodules = true;
    sha256 = "049gigx2s89z8vf17gscs00c150lmcdwya311nbrwa18fz4bx242";
  };

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ fftw libGL libX11 libjack2 liblo lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  prePatch = ''
    patchShebangs generate-ttl.sh
    cp patch/NanoVG.cpp lib/DPF/dgl/src/NanoVG.cpp
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Audio plugins for Linux";
    longDescription = ''
      Plugin List:
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
