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
, libobjc
, Cocoa
, CoreServices
, WebKit
, DiscRecording

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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "ADLplug";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0mqx4bzri8s880v7jwd24nb93m5i3aklqld0b3h0hjnz0lh2qz0f";
  };

  # All of these patches can be cleaned up if we can update ADLplug to the
  # latest, unreleased version. (It updates its bundled version of JUCE so
  # that it contains all of these changes.)
  #
  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/jpcima/ADLplug/83636c55bec1b86cabf634b9a6d56d07f00ecc61/resources/patch/juce-gcc9.patch";
      sha256 = "15hkdb76n9lgjsrpczj27ld9b4804bzrgw89g95cj4sc8wwkplyy";
      extraPrefix = "thirdparty/JUCE/";
      stripLen = 1;
    })

    (fetchpatch {
      #
      # Commit message:
      #
      #   macOS: Added missing OS versions to SystemStats::OperatingSystemType
      #
      # This is present by default in JUCE version 5.4.4.
      #
      # Needed so that subsequent patches apply cleanly.
      #
      url = "https://github.com/juce-framework/JUCE/commit/730fd6955fb1397c6da6774aeda1c7fa39792ce5.patch";
      sha256 = "UT01GnnxGVIHupxPXD4HNifcPZR+zauqQQ3mzWOr3yQ=";
      extraPrefix = "thirdparty/JUCE/";
      stripLen = 1;
    })
    (fetchpatch {
      #
      # Commit message:
      #
      #   Prevented the Apple system headers from including some unnecessary C library headers
      #
      # This is present by default in JUCE version 5.4.4.
      #
      # Needed so that subsequent patches apply cleanly.
      #
      url = "https://github.com/juce-framework/JUCE/commit/2830ecec0a24035ddfe383475243b397841af289.patch";
      sha256 = "I3mS9HE10L0v5IWchvyL6cNozrvw60np0EYK+SEblxM=";
      extraPrefix = "thirdparty/JUCE/";
      stripLen = 1;
    })
    (fetchpatch {
      # Commit message:
      #
      #   Build: Fix Xcode 11.4 compatibility issues
      #
      # This is present by default in JUCE version 6.0.0.
      #
      url = "https://github.com/juce-framework/JUCE/commit/dddeb1ad68f8539f5ea2fbac36c07532f12bf9cf.patch";
      sha256 = "B51UqvyHuc3beqkMp1mXE0aQ/yHbVioH0MPwAW4KHt8=";
      extraPrefix = "thirdparty/JUCE/";
      stripLen = 1;
    })
    (fetchpatch {
      # Commit message:
      #
      #   Cleanup: Remove redundant inlines
      #
      # This is present by default in JUCE version 6.0.0.
      #
      # Needed so that subsequent patches apply cleanly.
      #
      url = "https://github.com/juce-framework/JUCE/commit/4cf66d65221bee100c3de490ca3fe6fafc72f508.patch";
      sha256 = "Jw4OeNcRNgNT9hYdl/juo2w81G4QWNoplyoZZ1m4VMo=";
      extraPrefix = "thirdparty/JUCE/";
      stripLen = 1;
      includes = [
        "thirdparty/JUCE/modules/juce_core/native/juce_osx_ObjCHelpers.h"
      ];
    })
    (fetchpatch {
      # Commit message:
      #
      #   macOS: Initial support for macOS 11 and arm64
      #
      # This fixes objc_msgSend_fpret is an unknown symbol errors.
      #
      # This is present by default in JUCE version 6.0.2.
      #
      url = "https://github.com/juce-framework/JUCE/commit/b27017a5e3db1d6acf11d89f35adfe7de8bdb600.patch";
      sha256 = "NxOawDc3c6JFf9g0rg5KK9j2aS1VkTwel8WfYTfOYcs=";
      extraPrefix = "thirdparty/JUCE/";
      stripLen = 1;
      excludes = [
        "thirdparty/JUCE/docs/CMake API.md"
      ];
    })
  ];

  cmakeFlags = [
    "-DADLplug_CHIP=${chip}"
    "-DADLplug_USE_SYSTEM_FMT=ON"
    "-DADLplug_Jack=${if withJack then "ON" else "OFF"}"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin (toString [
    "-isystem ${CoreServices}/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers"
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
    libobjc
    Cocoa
    CoreServices
    WebKit
    DiscRecording
  ] ++ lib.optional withJack jack;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/${mainProgram}.app $out/Applications/
    ln -s $out/{Applications/${mainProgram}.app/Contents/MacOS,bin}/${mainProgram}
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
