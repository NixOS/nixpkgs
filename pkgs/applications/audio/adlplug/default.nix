{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, fmt
, liblo
, alsa-lib
, freetype
, libX11
, libXrandr
, libXinerama
, libXext
, libXcursor
, Foundation
, Cocoa
, Carbon
, CoreServices
, ApplicationServices
, CoreAudio
, CoreMIDI
, AudioToolbox
, Accelerate
, CoreImage
, IOKit
, AudioUnit
, QuartzCore
, WebKit
, DiscRecording
, CoreAudioKit

  # Enabling JACK requires a JACK server at runtime, no fallback mechanism
, withJack ? false, jack

, type ? "ADL"
}:

assert lib.assertOneOf "type" type [ "ADL" "OPN" ];
let
  chip = {
    ADL = "OPL3";
    OPN = "OPN2";
  }.${type};
  mainProgram = "${type}plug";
in
stdenv.mkDerivation rec {
  pname = "${lib.strings.toLower type}plug";
  version = "unstable-2021-12-17";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "ADLplug";
    rev = "a488abedf1783c61cb4f0caa689f1b01bf9aa17d";
    fetchSubmodules = true;
    sha256 = "1a5zw0rglqgc5wq1n0s5bxx7y59dsg6qy02236fakl34bvbk60yz";
  };

  cmakeFlags = [
    "-DADLplug_CHIP=${chip}"
    "-DADLplug_USE_SYSTEM_FMT=ON"
    "-DADLplug_Jack=${if withJack then "ON" else "OFF"}"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin (toString [
    # "fp.h" file not found
    "-isystem ${CoreServices}/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers"
  ]);

  NIX_LDFLAGS = toString (lib.optionals stdenv.hostPlatform.isDarwin [
    # Framework that JUCE needs which don't get linked properly
    "-framework CoreAudioKit"
    "-framework QuartzCore"
    "-framework AudioToolbox"
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    # JUCE dlopen's these at runtime
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ]);

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fmt
    liblo
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    freetype
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Foundation
    Cocoa
    Carbon
    CoreServices
    ApplicationServices
    CoreAudio
    CoreMIDI
    AudioToolbox
    Accelerate
    CoreImage
    IOKit
    AudioUnit
    QuartzCore
    WebKit
    DiscRecording
    CoreAudioKit
  ] ++ lib.optional withJack jack;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,Library/Audio/Plug-Ins/{VST,Components}}

    mv $out/bin/${mainProgram}.app $out/Applications/
    ln -s $out/{Applications/${mainProgram}.app/Contents/MacOS,bin}/${mainProgram}

    mv vst2/${mainProgram}.vst $out/Library/Audio/Plug-Ins/VST/
    mv au/${mainProgram}.component $out/Library/Audio/Plug-Ins/Components/
  '';

  meta = with lib; {
    inherit mainProgram;
    description = "${chip} FM Chip Synthesizer";
    homepage = src.meta.homepage;
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
