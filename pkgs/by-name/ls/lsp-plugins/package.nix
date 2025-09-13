{
  lib,
  stdenv,
  cairo,
  fetchurl,
  gst_all_1,
  jack2,
  ladspaH,
  libGL,
  libGLU,
  libXrandr,
  libsndfile,
  lv2,
  php82,
  pkg-config,
}:

let
  php = php82;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "lsp-plugins";
  version = "1.2.23";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchurl {
    url = "https://github.com/lsp-plugins/lsp-plugins/releases/download/${finalAttrs.version}/lsp-plugins-src-${finalAttrs.version}.tar.gz";
    hash = "sha256-GxjSnDsEPiXbaJ9khSvgQZeVONxWf4WJilurHpSf14w=";
  };

  # By default, GStreamer plugins are installed right alongside GStreamer itself
  # We can't do that in Nixpkgs, so lets install it to $out/lib like other plugins
  postPatch = ''
    substituteInPlace modules/lsp-plugin-fw/src/Makefile \
      --replace-fail '$(shell pkg-config --variable=pluginsdir gstreamer-1.0)' '$(LIBDIR)/gstreamer-1.0'
  '';

  nativeBuildInputs = [
    php
    pkg-config
  ];

  buildInputs = [
    cairo
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    jack2
    ladspaH
    libGL
    libGLU
    libXrandr
    libsndfile
    lv2
  ];

  makeFlags = [
    "ETCDIR=${placeholder "out"}/etc"
    "PREFIX=${placeholder "out"}"
    "SHAREDDIR=${placeholder "out"}/share"
  ];

  env.NIX_CFLAGS_COMPILE = "-DLSP_NO_EXPERIMENTAL";

  configurePhase = ''
    runHook preConfigure

    make $makeFlags config

    runHook postConfigure
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Collection of open-source audio plugins";
    longDescription = ''
      Compatible with the following formats:

      - CLAP - set of plugins for Clever Audio Plugins API
      - LADSPA - set of plugins for Linux Audio Developer's Simple Plugin API
      - LV2 - set of plugins and UIs for Linux Audio Developer's Simple Plugin API (LADSPA) version 2
      - LinuxVST - set of plugins and UIs for Steinberg's VST 2.4 format ported on GNU/Linux Platform
      - JACK - Standalone versions for JACK Audio connection Kit with UI

      Contains the following plugins (https://lsp-plug.in/?page=plugins)

      Equalizers:
      - Fliter
      - Graphic Equalizer
      - Parametric Equalizer
      Dynamic Processing:
      - Compressor
      - Dynamic Processor
      - Expander
      - Gate
      - Limiter
      Multiband Dynamic Processing:
      - GOTT Compressor
      - Multiband Compressor
      - Multiband Dynamics Processor
      - Multiband Expander
      - Multiband Gate
      - Multiband Limiter
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
      - Flanger
      - Latency Meter
      - Loudness Compensator
      - Mixer
      - Profiler
      - Surge Filter
      - Trigger
    '';
    homepage = "https://lsp-plug.in";
    changelog = "https://github.com/lsp-plugins/lsp-plugins/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      magnetophon
      PowerUser64
    ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
