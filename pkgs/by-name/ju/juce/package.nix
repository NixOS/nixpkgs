{ lib
, stdenv
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems

  # Native build inputs
, cmake
, pkg-config
, makeWrapper

  # Dependencies
, alsa-lib
, freetype
, curl
, libglvnd
, webkitgtk
, pcre
, darwin
, ladspaH

  # Options
, buildExtras ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "juce";
  version = "7.0.10";

  src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "juce";
    rev = finalAttrs.version;
    hash = "sha256-CAHhHPTUvIyDOh2CdvNmw26HfoWWtbqRRiR+3Ky4GYA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ] ++ lib.optionals buildExtras [
    copyDesktopItems
  ];

  cmakeFlags = lib.optionals buildExtras [
    "-DJUCE_BUILD_EXTRAS=ON"
  ];

  buildInputs = [
    freetype # libfreetype.so
    curl # libcurl.so
    stdenv.cc.cc.lib # libstdc++.so libgcc_s.so
    pcre # libpcre2.pc
  ] ++ lib.optionals buildExtras [
    ladspaH
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib # libasound.so
    libglvnd # libGL.so
    webkitgtk # webkit2gtk-4.0
  ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [
      Cocoa
      MetalKit
      WebKit
    ] ++ lib.optionals buildExtras [
      DiscRecording
      CoreAudioKit
      Accelerate
      StoreKit
    ]);

  postPatch = lib.optionalString (stdenv.isDarwin && buildExtras) ''
    substituteInPlace extras/Build/CMake/JUCEHelperTargets.cmake --replace "-flto" ""
  '';

  desktopItems = lib.optionals buildExtras [
    (makeDesktopItem
      {
        name = "Projucer";
        desktopName = "Projucer";
        genericName = "JUCE project management tool";
        comment = "IDE for working with JUCE based projects";
        exec = "Projucer %f";
        icon = "juce.png";
        categories = [ "Development" ];
        mimeTypes = [ "application/x-juce" ];
        keywords = [ "Development" "IDE" "C++" ];
      })
  ];

  postInstall = lib.optionalString buildExtras (
    let
      appCheck = isApp: isApp && stdenv.isDarwin;
      appSuffix = isApp: if appCheck isApp then ".app" else "";
      outDir = isApp: if appCheck isApp then "$out/Applications" else "$out/bin";
      artefactPath = name: isApp: "extras/${name}/${name}_artefacts/Release/${name}${appSuffix isApp}";
      mvArtefact = name: isApp: "mv ${artefactPath name isApp} ${outDir isApp}";
    in
    ''
      ${lib.optionalString stdenv.isDarwin "mkdir $out/Applications"}

      ${mvArtefact "Projucer" true}
      ${mvArtefact "NetworkGraphicsDemo" true}
      ${mvArtefact "AudioPluginHost" true}
      ${mvArtefact "AudioPerformanceTest" true}
      ${mvArtefact "UnitTestRunner" false}
      ${mvArtefact "BinaryBuilder" false}

      mkdir -p $out/share/pixmaps
      cp $src/extras/Projucer/Source/BinaryData/Icons/juce_icon.png $out/share/pixmaps/juce.png
    ''
  );

  meta = with lib; {
    description = "Cross-platform C++ application framework";
    longDescription = "JUCE is an open-source cross-platform C++ application framework for desktop and mobile applications, including VST, VST3, AU, AUv3, RTAS and AAX audio plug-ins";
    homepage = "https://github.com/juce-framework/JUCE";
    license = with licenses; [ isc gpl3Plus ];
    mainProgram = "juceaide";
    maintainers = with maintainers; [ liarokapisv kashw2 ];
    platforms = platforms.all;
  };
})
