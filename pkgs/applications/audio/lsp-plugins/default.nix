{ stdenv, fetchFromGitHub, pkgconfig, makeWrapper
, libsndfile, jack2Full
, libGLU, libGL, lv2, cairo
, ladspaH, php, expat }:

stdenv.mkDerivation rec {
  pname = "lsp-plugins";
  version = "1.1.5";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "sadko4u";
    repo = "${pname}";
    rev = "${name}";
    sha256 = "0xcxm47j7mz5vprjqqhi95gz62syp4y737h7cssxd3flqkgar7xr";
  };

  nativeBuildInputs = [ pkgconfig php expat ];
  buildInputs = [ jack2Full libsndfile libGLU libGL lv2 cairo ladspaH makeWrapper ];

  makeFlags = [
    "BIN_PATH=$(out)/bin"
    "LIB_PATH=$(out)/lib"
    "DOC_PATH=$(out)/share/doc"
  ];

  NIX_CFLAGS_COMPILE = [ "-DLSP_NO_EXPERIMENTAL" ];

  patchPhase = ''
    runHook prePatch
    substituteInPlace Makefile --replace "/usr/lib" "$out/lib"
    substituteInPlace ./include/container/jack/main.h --replace "/usr/lib" "$out/lib"
    substituteInPlace ./include/container/vst/main.h --replace "/usr/lib" "$out/lib"
    # for https://github.com/sadko4u/lsp-plugins/issues/7#issuecomment-426561549 :
    sed -i '/X11__NET_WM_WINDOW_TYPE_DOCK;/d' ./src/ui/ws/x11/X11Window.cpp
    runHook postPatch
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    TEST_PATH=$(pwd)".build-test"
    make OBJDIR=$TEST_PATH test
    $TEST_PATH/lsp-plugins-test utest
    runHook postCheck
  '';

  buildFlags = "release";

  meta = with stdenv.lib;
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
        - Latency Meter - Latenzmessgerät
        - Multiband Compressor LeftRight x8 - Multi-band Kompressor LeftRight x8
        - Multiband Compressor MidSide x8 - Multi-band Kompressor MidSide x8
        - Multiband Compressor Mono x8 - Multi-band Kompressor Mono x8
        - Multiband Compressor Stereo x8 - Multi-band Kompressor Stereo x8
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
        - Multi-Sampler x12 DirectOut - Schlagzeug x12 Direktausgabe
        - Multi-Sampler x12 Stereo - Schlagzeug x12 Stereo
        - Multi-Sampler x24 DirectOut - Schlagzeug x24 Direktausgabe
        - Multi-Sampler x24 Stereo - Schlagzeug x24 Stereo
        - Multi-Sampler x48 DirectOut - Schlagzeug x48 Direktausgabe
        - Multi-Sampler x48 Stereo - Schlagzeug x48 Stereo
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
        - Trigger MIDI Mono - Triggersensor MIDI Mono
        - Trigger MIDI Stereo - Triggersensor MIDI Stereo
        - Trigger Mono - Triggersensor Mono
        - Trigger Stereo - Triggersensor Stereo
        - Delay Compensator Mono - Verzögerungsausgleicher Mono
        - Delay Compensator Stereo - Verzögerungsausgleicher Stereo
        - Delay Compensator x2 Stereo - Verzögerungsausgleicher x2 Stereo
      '';
      homepage = https://lsp-plug.in;
      maintainers = with maintainers; [ magnetophon ];
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
