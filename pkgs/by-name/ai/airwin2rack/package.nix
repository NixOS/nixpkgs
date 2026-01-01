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
  xorg,
  freetype,
  libGLU,
  libjack2,
  juce,
  webkitgtk_4_1,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libxkbcommon,
  libdatrie,
  libepoxy,
  libsoup_3,
  lerc,
  sqlite,
  libdeflate,
  xz,
  libwebp,
  glib,
  gtk3-x11,
  curl,
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
<<<<<<< HEAD
    rev = "645ed2fd0949d36639e3d63333f26136df6df769";
    hash = "sha256-Lx88nyEFjPLA5yh8rrqBdyZIxe/j0FgIHoyKcbjuuI4=";
=======
    rev = "4f33b4930b6af806018c009f0f24b3a50808af99";
    hash = "sha256-M+T7ll3Ap6VIP5ub+kfEKwT2RW2IxxY4wUPRQKFIotk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  vcvRackSdk = srcOnly vcv-rack;
  pname = "airwin2rack";
<<<<<<< HEAD
  version = "2.13.0-unstable-2025-12-07";
=======
  version = "2.13.0-unstable-2025-09-14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
stdenv.mkDerivation {
  inherit pname;
  inherit version;

  src = fetchFromGitHub {
    owner = "baconpaul";
    repo = "airwin2rack";
<<<<<<< HEAD
    rev = "a797d6c7a453006c6a08db32d7bb373ecccb572b";
    hash = "sha256-+xGLVp4eR7Xb2dSEyfyHfAcoZGRSzL49l/U89N2VX+w=";
=======
    rev = "fc75563323bd9d8e46b1d58d89830e0bf760f0e8";
    hash = "sha256-7jCDNbGMfJBo2xvRsDYdlEKSpAiRDNm6N4jTYCu+kKs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXdmcp
    libGLU
    libjack2
    freetype
    webkitgtk_4_1
    glib
    gtk3-x11
    curl
    libsysprof-capture
    pcre2
    util-linux
    libselinux
    libsepol
    libthai
    libxkbcommon
    libdatrie
    libepoxy
    libsoup_3
    lerc
    sqlite
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

  preConfigure = lib.optionalString enableVCVRack ''export RACK_DIR=${vcvRackSdk}'';

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
      "-lXtst"
      "-lXdmcp"
    ]
  );

  meta = {
    description = "JUCE Plugin Version of Airwindows Consolidated";
    homepage = "https://airwindows.com/";
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
