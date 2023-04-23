{ lib, stdenv, fetchurl, pkg-config, makeWrapper
, libsndfile, jack2
, libGLU, libGL, lv2, cairo
, ladspaH, php, libXrandr }:

stdenv.mkDerivation rec {
  pname = "lsp-plugins";
  version = "1.2.6";

  src = fetchurl {
    url = "https://github.com/sadko4u/${pname}/releases/download/${version}/${pname}-src-${version}.tar.gz";
    sha256 = "sha256-lNrIsXW3ZNKMFwsl5qowWqK/ZaCaQUAlrSscnsOxvVg=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ pkg-config php makeWrapper ];
  buildInputs = [ jack2 libsndfile libGLU libGL lv2 cairo ladspaH libXrandr ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ETCDIR=${placeholder "out"}/etc"
    "SHAREDDIR=${placeholder "out"}/share"
  ];

  env.NIX_CFLAGS_COMPILE = "-DLSP_NO_EXPERIMENTAL";

  configurePhase = ''
    make config PREFIX=${placeholder "out"}
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib;
    { description = "Collection of open-source audio plugins";
      longDescription = ''
        Compatible with the following formats:

        - CLAP - set of plugins for Clever Audio Plugins API
        - LADSPA - set of plugins for Linux Audio Developer's Simple Plugin API
        - LV2 - set of plugins and UIs for Linux Audio Developer's Simple Plugin API (LADSPA) version 2
        - LinuxVST - set of plugins and UIs for Steinberg's VST 2.4 format ported on GNU/Linux Platform
        - JACK - Standalone versions for JACK Audio connection Kit with UI

        Contains the following plugins (https://lsp-plug.in/?page=plugins)

        Equalizers:
        - Graphic Equalizer
        - Parametric Equalizer
        Dynamic Processing:
        - Compressor
        - Dynamic Processor
        - Expander
        - Gate
        - Limiter
        Multiband Dynamic Processing:
        - Multiband Compressor
        - Multiband Dynamic Processor
        - Multiband Expander
        - Multiband Gate
        Convolution / Reverb processing:
        - Impulse Responses
        - Impulse Reverb
        - Room Builder
        Delay Effects:
        - Artistic Delay
        - Compensation Delay
        - Slap-back Delay
        Analyzers:
        - Oscilloscope
        - Phase Detector
        - Spectrum Analyzer
        Multiband Processing:
        - Crossover
        Samplers:
        - Multisampler
        - Sampler
        Generators / Oscillators:
        - Noise Generator
        - Oscillator
        Utilitary Plugins:
        - A/B Test Plugin
        - Latency Meter
        - Loudness Compensator
        - Mixer
        - Profiler
        - Surge Filter
        - Trigger
      '';
      homepage = "https://lsp-plug.in";
      maintainers = with maintainers; [ magnetophon ];
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
