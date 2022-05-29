{ stdenv
, lib
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, alsa-lib
, curl
, freetype
, libjack2
, libX11
, libXcursor
, libXext
, libXinerama
, libXrandr
, lv2
, pcre
, util-linux
, webkitgtk
}:

let
  juce-lv2 = fetchFromGitHub {
    owner = "lv2-porting-project";
    repo = "JUCE";
    rev = "5106d9d77b892c22afcb9379c13982f270429e2e";
    hash = "sha256-bpZJ5NEDRfMtmx0RkKQFZWqS/SnYAFRhrDg9MSphh4c=";
  };
in
stdenv.mkDerivation {
  # Use TitleCase to align with the binary name
  pname = "MoniqueMonosynth";
  version = "2022-05-02";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "monique-monosynth";
    rev = "ba94f7bf926908345a3f61eb91e43421df60dd1c";
    hash = "sha256-6YRfF/UlqiXAmayfzGOLqq4ND/H4kPzWe4tVD0IXR4Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];

  buildInputs = [
    alsa-lib
    curl
    freetype
    libjack2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    lv2
    pcre
    util-linux
    webkitgtk
  ];

  cmakeFlags = [
    "-DJUCE_SUPPORTS_LV2=ON"
    "-DMONIQUE_JUCE_PATH=${juce-lv2}"
  ];

  # LTO introduces "undefined references to ..." at link time
  # -Werror produces errors with recent versions of GCC (and is discouraged)
  patches = [ ./no-lto-no-werror.patch ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/vst3 $out/lib/lv2

    cp -r MoniqueMonosynth_artefacts/Release/LV2/MoniqueMonosynth.lv2 $out/lib/lv2
    cp -r MoniqueMonosynth_artefacts/Release/VST3/MoniqueMonosynth.vst3 $out/lib/vst3
    cp -r MoniqueMonosynth_artefacts/Release/Standalone/MoniqueMonosynth $out/bin
  '';

  meta = with lib; {
    description = "A monophonic synth from Thomas Arndt";
    homepage = "https://github.com/surge-synthesizer/monique-monosynth";
    license = with licenses; [ gpl3Only mit ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ minijackson ];
  };
}
