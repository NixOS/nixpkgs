{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fmt,
  liblo,
  alsa-lib,
  freetype,
  libX11,
  libXrandr,
  libXinerama,
  libXext,
  libXcursor,

  # Enabling JACK requires a JACK server at runtime, no fallback mechanism
  withJack ? false,
  libjack2,

  type ? "ADL",
}:

assert lib.assertOneOf "type" type [
  "ADL"
  "OPN"
];
let
  chip =
    {
      ADL = "OPL3";
      OPN = "OPN2";
    }
    .${type};
  mainProgram = "${type}plug";
in
stdenv.mkDerivation {
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
    (lib.cmakeFeature "ADLplug_CHIP" chip)
    (lib.cmakeBool "ADLplug_USE_SYSTEM_FMT" true)
    (lib.cmakeBool "ADLplug_Jack" withJack)
  ];

  NIX_LDFLAGS = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      # Framework that JUCE needs which don't get linked properly
      "-framework CoreAudioKit"
      "-framework QuartzCore"
      "-framework AudioToolbox"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # JUCE dlopen's these at runtime
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
    ]
  );

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fmt
    liblo
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    freetype
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
  ]
  ++ lib.optionals withJack [ libjack2 ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,Library/Audio/Plug-Ins/{VST,Components}}

    mv $out/bin/${mainProgram}.app $out/Applications/
    ln -s $out/{Applications/${mainProgram}.app/Contents/MacOS,bin}/${mainProgram}

    mv vst2/${mainProgram}.vst $out/Library/Audio/Plug-Ins/VST/
    mv au/${mainProgram}.component $out/Library/Audio/Plug-Ins/Components/
  '';

  meta = {
    inherit mainProgram;
    description = "${chip} FM Chip Synthesizer";
    homepage = "https://github.com/jpcima/ADLplug";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
}
