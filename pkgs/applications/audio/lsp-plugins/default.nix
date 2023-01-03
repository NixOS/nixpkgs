{ lib, stdenv, fetchurl, pkg-config, makeWrapper
, libsndfile, jack2
, libGLU, libGL, lv2, cairo
, ladspaH, php, libXrandr }:

stdenv.mkDerivation rec {
        pname = "lsp-plugins";
        version = "1.2.4";

        src = fetchurl {
                url = "https://github.com/sadko4u/${pname}/releases/download/${version}/${pname}-src-${version}.tar.gz";
                sha256 = "sha256-GTrcUy10bN9Xj2I7uuGyP82c6NVpnQbXTI85H231yyo=";
        };

        nativeBuildInputs = [ pkg-config php makeWrapper ];
        buildInputs = [ jack2 libsndfile libGLU libGL lv2 cairo ladspaH libXrandr ];

        makeFlags = [
                "PREFIX=${placeholder "out"}"
  ];

  NIX_CFLAGS_COMPILE = "-DLSP_NO_EXPERIMENTAL";

  configurePhase = ''
    make config PREFIX=${placeholder "out"}
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib;
    { description = "Collection of open-source audio plugins";
      longDescription = ''
        Compatible with follwing formats:

        - LADSPA - set of plugins for Linux Audio Developer's Simple Plugin API
        - LV2 - set of plugins and UIs for Linux Audio Developer's Simple Plugin API (LADSPA) version 2
        - LinuxVST - set of plugins and UIs for Steinberg's VST 2.4 format ported on GNU/Linux Platform
        - JACK - Standalone versions for JACK Audio connection Kit with UI

        Contains the following plugins:

        - Limiter Mono - Begrenzer Mono
        - Limiter Stereo - Begrenzer Stereo
        - Dynamic Processor LeftRight - Dynamikprozessor LeftRight
        - Dynamic Processor MidSide - Dynamikprozessor MidSide
        - Dynamic Processor Mono - Dynamikprozessor Mono
        - Dynamic Processor Stereo - Dynamikprozessor Stereo
        - Expander LeftRight - Expander LeftRight
        - Expander MidSide - Expander MidSide
        - Expander Mono - Expander Mono
        - Expander Stereo - Expander Stereo
        - Crossover LeftRight x8 - Frequenzweiche LeftRight x8
        - Crossover MidSide x8 - Frequenzweiche MidSide x8
        - Crossover Mono x8 - Frequenzweiche Mono x8
        - Crossover Stereo x8 - Frequenzweiche Stereo x8
        - Gate LeftRight - Gate LeftRight
        - Gate MidSide - Gate MidSide
        - Gate Mono - Gate Mono
        - Gate Stereo - Gate Stereo
        - Graphic Equalizer x16 LeftRight - Grafischer Entzerrer x16 LeftRight
        - Graphic Equalizer x16 MidSide - Grafischer Entzerrer x16 MidSide
        - Graphic Equalizer x16 Mono - Grafischer Entzerrer x16 Mono
        - Graphic Equalizer x16 Stereo - Grafischer Entzerrer x16 Stereo
        - Graphic Equalizer x32 LeftRight - Grafischer Entzerrer x32 LeftRight
        - Graphic Equalizer x32 MidSide - Grafischer Entzerrer x32 MidSide
        - Graphic Equalizer x32 Mono - Grafischer Entzerrer x32 Mono
        - Graphic Equalizer x32 Stereo - Grafischer Entzerrer x32 Stereo
        - Impulse Responses Mono - Impulsantworten Mono
        - Impulse Responses Stereo - Impulsantworten Stereo
        - Impulse Reverb Mono - Impulsnachhall Mono
        - Impulse Reverb Stereo - Impulsnachhall Stereo
        - Sampler Mono - Klangerzeuger Mono
        - Sampler Stereo - Klangerzeuger Stereo
        - Compressor LeftRight - Kompressor LeftRight
        - Compressor MidSide - Kompressor MidSide
        - Compressor Mono - Kompressor Mono
        - Compressor Stereo - Kompressor Stereo
        - Artistic Delay Mono - Künstlerische Verzögerung
        - Artistic Delay Stereo - Künstlerische Verzögerung
        - Latency Meter - Latenzmessgerät
        - Loudness Compensator Mono - Lautstärke Kompensator Mono
        - Loudness Compensator Stereo - Lautstärke Kompensator Stereo
        - Multiband Expander LeftRight x8 - Multi-band Expander LeftRight x8
        - Multiband Expander MidSide x8 - Multi-band Expander MidSide x8
        - Multiband Expander Mono x8 - Multi-band Expander Mono x8
        - Multiband Expander Stereo x8 - Multi-band Expander Stereo x8
        - Multiband Gate LeftRight x8 - Multi-band Gate LeftRight x8
        - Multiband Gate MidSide x8 - Multi-band Gate MidSide x8
        - Multiband Gate Mono x8 - Multi-band Gate Mono x8
        - Multiband Gate Stereo x8 - Multi-band Gate Stereo x8
        - Multiband Compressor LeftRight x8 - Multi-band Kompressor LeftRight x8
        - Multiband Compressor MidSide x8 - Multi-band Kompressor MidSide x8
        - Multiband Compressor Mono x8 - Multi-band Kompressor Mono x8
        - Multiband Compressor Stereo x8 - Multi-band Kompressor Stereo x8
        - Oscilloscope x1 - Oscilloscope x1
        - Oscilloscope x2 - Oscilloscope x2
        - Oscilloscope x4 - Oscilloscope x4
        - Oscillator Mono - Oszillator Mono
        - Parametric Equalizer x16 LeftRight - Parametrischer Entzerrer x16 LeftRight
        - Parametric Equalizer x16 MidSide - Parametrischer Entzerrer x16 MidSide
        - Parametric Equalizer x16 Mono - Parametrischer Entzerrer x16 Mono
        - Parametric Equalizer x16 Stereo - Parametrischer Entzerrer x16 Stereo
        - Parametric Equalizer x32 LeftRight - Parametrischer Entzerrer x32 LeftRight
        - Parametric Equalizer x32 MidSide - Parametrischer Entzerrer x32 MidSide
        - Parametric Equalizer x32 Mono - Parametrischer Entzerrer x32 Mono
        - Parametric Equalizer x32 Stereo - Parametrischer Entzerrer x32 Stereo
        - Phase Detector - Phasendetektor
        - Profiler Mono - Profiler Mono
        - Profiler Stereo - Profiler Stereo
        - Room Builder Mono - Raumbaumeister Mono
        - Room Builder Stereo - Raumbaumeister Stereo
        - Multi-Sampler x12 DirectOut - Schlagzeug x12 Direktausgabe
        - Multi-Sampler x12 Stereo - Schlagzeug x12 Stereo
        - Multi-Sampler x24 DirectOut - Schlagzeug x24 Direktausgabe
        - Multi-Sampler x24 Stereo - Schlagzeug x24 Stereo
        - Multi-Sampler x48 DirectOut - Schlagzeug x48 Direktausgabe
        - Multi-Sampler x48 Stereo - Schlagzeug x48 Stereo
        - Sidechain Multiband Expander LeftRight x8 - Sidechain Multi-band Expander LeftRight x8
        - Sidechain Multiband Expander MidSide x8 - Sidechain Multi-band Expander MidSide x8
        - Sidechain Multiband Expander Mono x8 - Sidechain Multi-band Expander Mono x8
        - Sidechain Multiband Expander Stereo x8 - Sidechain Multi-band Expander Stereo x8
        - Sidechain Multiband Gate LeftRight x8 - Sidechain Multi-band Gate LeftRight x8
        - Sidechain Multiband Gate MidSide x8 - Sidechain Multi-band Gate MidSide x8
        - Sidechain Multiband Gate Mono x8 - Sidechain Multi-band Gate Mono x8
        - Sidechain Multiband Gate Stereo x8 - Sidechain Multi-band Gate Stereo x8
        - Sidechain Multiband Compressor LeftRight x8 - Sidechain Multi-band Kompressor LeftRight x8
        - Sidechain Multiband Compressor MidSide x8 - Sidechain Multi-band Kompressor MidSide x8
        - Sidechain Multiband Compressor Mono x8 - Sidechain Multi-band Kompressor Mono x8
        - Sidechain Multiband Compressor Stereo x8 - Sidechain Multi-band Kompressor Stereo x8
        - Sidechain Limiter Mono - Sidechain-Begrenzer Mono
        - Sidechain Limiter Stereo - Sidechain-Begrenzer Stereo
        - Sidechain Dynamic Processor LeftRight - Sidechain-Dynamikprozessor LeftRight
        - Sidechain Dynamic Processor MidSide - Sidechain-Dynamikprozessor MidSide
        - Sidechain Dynamic Processor Mono - Sidechain-Dynamikprozessor Mono
        - Sidechain Dynamic Processor Stereo - Sidechain-Dynamikprozessor Stereo
        - Sidechain Expander LeftRight - Sidechain-Expander LeftRight
        - Sidechain Expander MidSide - Sidechain-Expander MidSide
        - Sidechain Expander Mono - Sidechain-Expander Mono
        - Sidechain Expander Stereo - Sidechain-Expander Stereo
        - Sidechain Gate LeftRight - Sidechain-Gate LeftRight
        - Sidechain Gate MidSide - Sidechain-Gate MidSide
        - Sidechain Gate Mono - Sidechain-Gate Mono
        - Sidechain Gate Stereo - Sidechain-Gate Stereo
        - Sidechain Compressor LeftRight - Sidechain-Kompressor LeftRight
        - Sidechain Compressor MidSide - Sidechain-Kompressor MidSide
        - Sidechain Compressor Mono - Sidechain-Kompressor Mono
        - Sidechain Compressor Stereo - Sidechain-Kompressor Stereo
        - Slapback Delay Mono - Slapback-Delay Mono
        - Slapback Delay Stereo - Slapback-Delay Stereo
        - Spectrum Analyzer x1 - Spektrumanalysator x1
        - Spectrum Analyzer x12 - Spektrumanalysator x12
        - Spectrum Analyzer x16 - Spektrumanalysator x16
        - Spectrum Analyzer x2 - Spektrumanalysator x2
        - Spectrum Analyzer x4 - Spektrumanalysator x4
        - Spectrum Analyzer x8 - Spektrumanalysator x8
        - Surge Filter Mono - Sprungfilter Mono
        - Surge Filter Stereo - Sprungfilter Stereo
        - Trigger MIDI Mono - Triggersensor MIDI Mono
        - Trigger MIDI Stereo - Triggersensor MIDI Stereo
        - Trigger Mono - Triggersensor Mono
        - Trigger Stereo - Triggersensor Stereo
        - Delay Compensator Mono - Verzögerungsausgleicher Mono
        - Delay Compensator Stereo - Verzögerungsausgleicher Stereo
        - Delay Compensator x2 Stereo - Verzögerungsausgleicher x2 Stereo
      '';
      homepage = "https://lsp-plug.in";
      maintainers = with maintainers; [ magnetophon ];
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
