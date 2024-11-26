{
  lib,
  stdenv,
  fetchFromGitHub,
  vapoursynth,
}:

stdenv.mkDerivation {
  pname = "vapoursynth-znedi3";
  version = "unstable-2023-07-09";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "sekrit-twc";
    repo = "znedi3";
    rev = "68dc130bc37615fd912d1dc1068261f00f54b146";
    hash = "sha256-QC+hMMfp6XwW4PqsN6sip1Y7ttiYn/xuxq/pUg/trog=";
  };

  buildInputs = [ vapoursynth ];

  postPatch = ''
    rm -rf vsxx/vapoursynth
    ln -s ${vapoursynth}/include/vapoursynth vsxx/vapoursynth
  '';

  makeFlags =
    [ "CPPFLAGS=-DNNEDI3_WEIGHTS_PATH='\"$(out)/share/nnedi3/nnedi3_weights.bin\"'" ]
    ++ lib.optionals stdenv.hostPlatform.isx86 [
      "X86=1"
      "X86_AVX512=1"
    ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/lib/vapoursynth vsznedi3.so
    install -D -m644 -t $out/share/nnedi3 nnedi3_weights.bin

    runHook postInstall
  '';

  meta = {
    inherit (vapoursynth.meta) platforms;
    description = "Filter for VapourSynth";
    homepage = "https://github.com/sekrit-twc/znedi3";
    license = with lib.licenses; [
      gpl2Plus
      wtfpl
      lgpl21
    ];
    maintainers = with lib.maintainers; [ snaki ];
  };
}
