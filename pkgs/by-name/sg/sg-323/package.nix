{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  fontconfig,
  freetype,
  libX11,
  libXcomposite,
  libXcursor,
  libXdmcp,
  libXext,
  libXinerama,
  libXrandr,
  libXtst,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SG-323";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "greyboxaudio";
    repo = "SG-323";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-DvA9Y7eAG0pWLmHEZmJlo0JLU+0B4c8rlkX1bbVcnL8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
  ]
  ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libX11
    libXcomposite
    libXcursor
    libXdmcp
    libXext
    libXinerama
    libXrandr
    libXtst
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
  '';

  installPhase =
    let
      vst3Dir =
        if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/VST3" else "$out/lib/vst3";
      # this one's a guess, don't know where ppl have agreed to put them yet
      clapDir =
        if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/CLAP" else "$out/lib/clap";
      auDir = "$out/Library/Audio/Plug-Ins/Components";
    in
    ''
      runHook preInstall

    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p ${auDir}
          cp -r "SG323_artefacts/Release/AU/SG-323.component" ${auDir}
        ''
      else
        ''
          mkdir -p $out/lib/lv2
          cp -r "SG323_artefacts/Release/LV2/SG-323.lv2" $out/lib/lv2
        ''
    )
    + ''
      mkdir -p ${vst3Dir} ${clapDir}
      mv SG323_artefacts/Release/VST3/* ${vst3Dir}
      mv SG323_artefacts/Release/CLAP/* ${clapDir}

      runHook postInstall
    '';

  meta = {
    description = "Ursa Major Stargate 323 reverb plugin";
    homepage = "https://github.com/greyboxaudio/SG-323";
    changelog = "https://github.com/greyboxaudio/SG-323/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.all;
  };
})
