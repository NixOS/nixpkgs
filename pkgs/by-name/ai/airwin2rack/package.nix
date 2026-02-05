{
  stdenv,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  copyDesktopItems,
  srcOnly,
  cmake,
  pkg-config,
  alsa-lib,
  libxrender,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  libxcomposite,
  libx11,
  fontconfig,
  freetype,
  libjack2,
  juce,
  libsoup_3,
  libdeflate,
  xz,
  libwebp,
  glib,
  vcv-rack,
  jansson,
  glew,
  glfw,
  libarchive,
  speexdsp,
  libpulseaudio,
  libsamplerate,
  rtmidi,
  zstd,
  jq,
  enableVCVRack ? false,
}:
let
  clapJuceExtensions = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "645ed2fd0949d36639e3d63333f26136df6df769";
    hash = "sha256-Lx88nyEFjPLA5yh8rrqBdyZIxe/j0FgIHoyKcbjuuI4=";
    fetchSubmodules = true;
  };

  vcvRackSdk = srcOnly vcv-rack;
  pname = "airwin2rack";
  version = "2.13.0-unstable-2026-01-19";
in
stdenv.mkDerivation {
  inherit pname;
  inherit version;

  src = fetchFromGitHub {
    owner = "baconpaul";
    repo = "airwin2rack";
    rev = "ed3700c223be0fd5eddf6d57b66216fff8389c2c";
    hash = "sha256-JHARxie6y3mD/ZLEMGmfK8/b5GBcN/7lHpm7kI5BpTs=";
    fetchSubmodules = true;
  };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "Airwin2rack";
      desktopName = "Airwindows Consolidated";
      comment = "Various Airwindows Plugins Consolidated (Standalone)";
      exec = "Airwindows Consolidated";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
  ]
  ++ lib.optionals enableVCVRack [
    jq
    zstd
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxcomposite
    libxcursor
    libxext
    libxinerama
    libxrandr
    libxrender
    fontconfig
    libjack2
    freetype
    glib
    libsoup_3
    libdeflate
    xz # liblzma
    libwebp
  ]
  ++ lib.optionals enableVCVRack [
    vcv-rack
    jansson
    glew
    glfw
    libarchive
    speexdsp
    libpulseaudio
    libsamplerate
    rtmidi
    zstd
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_JUCE_PLUGIN" true)
    (lib.cmakeBool "USE_JUCE_PROGRAMS" true)
  ]
  ++ lib.optionals enableVCVRack [
    (lib.cmakeBool "BUILD_RACK_PLUGIN" true)
    (lib.cmakeFeature "RACK_SDK_DIR" "${vcvRackSdk}")
  ];

  cmakeBuildType = "Release";

  patches = [
    ./juce-clap-juce-extensions-src-juce-cmakelists.patch
  ];

  prePatch = ''
    ln -s ${juce.src} src-juce/juce
    ln -s ${clapJuceExtensions} src-juce/clap-juce-extensions
  '';

  preConfigure = lib.optionalString enableVCVRack "export RACK_DIR=${vcvRackSdk}";

  buildPhase = ''
    runHook preBuild
    cmake --build . --target awcons-products ${lib.optionalString enableVCVRack "build_plugin"} --parallel $NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3 $out/lib/lv2 $out/lib/clap $out/bin

    cp -r "awcons-products/Airwindows Consolidated.vst3" $out/lib/vst3
    cp -r "awcons-products/Airwindows Consolidated.lv2" $out/lib/lv2
    install -Dm644 "awcons-products/Airwindows Consolidated.clap" -t $out/lib/clap

    install -Dm755 "awcons-products/Airwindows Consolidated" $out/bin/Airwindows\ Consolidated

    ${lib.optionalString enableVCVRack ''
      mkdir ../${pname}
      strip -s plugin.so
      mv plugin.so ../${pname}
      cd ..
      mv LICENSE.md ${pname}
      mv README.md ${pname}
      mv plugin.json ${pname}
      mv res ${pname}
      tar -c ${pname} | zstd -19 -o "${pname}-${version}-lin-x64.vcvplugin"
      # got the directory from arch wiki
      install -Dm755 "${pname}-${version}-lin-x64.vcvplugin" $out/usr/lib/vcvrack/plugins
    ''}

    runHook postInstall
  '';

  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcomposite"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
      "-lXrender"
    ]
  );

  meta = {
    description = "JUCE Plugin Version of Airwindows Consolidated";
    homepage = "https://github.com/baconpaul/airwin2rack";
    platforms = [ "x86_64-linux" ];
    license =
      with lib.licenses;
      [ mit ]
      ++ lib.optional enableVCVRack [
        gpl3Plus
        cc-by-nc-40
        unfreeRedistributable
      ];
    mainProgram = "Airwindows Consolidated";
    maintainers = [ lib.maintainers.l1npengtul ];
  };
}
