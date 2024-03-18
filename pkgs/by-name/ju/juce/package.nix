{ lib
, stdenv
, fetchFromGitHub

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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "juce";
  version = "7.0.9";

  src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "juce";
    rev = finalAttrs.version;
    hash = "sha256-k8cNTPH9OgOav4dsSLqrd5PlJ1rqO0PLt6Lwmumc2Gg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  cmakeFlags = [
    "-DJUCE_BUILD_EXTRAS=ON"
  ];

  buildInputs = [
    ladspaH
    freetype # libfreetype.so
    curl # libcurl.so
    stdenv.cc.cc.lib # libstdc++.so libgcc_s.so
    pcre # libpcre2.pc
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib # libasound.so
    libglvnd # libGL.so
    webkitgtk # webkit2gtk-4.0
  ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [
      Cocoa
      MetalKit
      WebKit
      DiscRecording
      CoreAudioKit
      Accelerate
      StoreKit
    ]);

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace extras/Build/CMake/JUCEHelperTargets.cmake --replace "-flto" ""
  '';

  postInstall =
    let
      appCheck = isApp: isApp && stdenv.isDarwin;
      appSuffix = isApp: if appCheck isApp then ".app" else "";
      outDir = isApp: if appCheck isApp then "$out/Applications" else "$out/bin";
      artifactPath = name: isApp: "extras/${name}/${name}_artefacts/Release/${name}${appSuffix isApp}";
      mvArtefact = name: isApp: "mv ${artifactPath name isApp} ${outDir isApp}";
    in
    ''
      ${lib.optionalString stdenv.isDarwin "mkdir $out/Applications"}

      ${mvArtefact "Projucer" true}
      ${mvArtefact "NetworkGraphicsDemo" true}
      ${mvArtefact "AudioPluginHost" true}
      ${mvArtefact "AudioPerformanceTest" true}
      ${mvArtefact "UnitTestRunner" false}
      ${mvArtefact "BinaryBuilder" false}
    '';

  meta = with lib; {
    description = "Cross-platform C++ application framework";
    longDescription = "JUCE is an open-source cross-platform C++ application framework for desktop and mobile applications, including VST, VST3, AU, AUv3, RTAS and AAX audio plug-ins";
    homepage = "https://github.com/juce-framework/JUCE";
    license = with licenses; [ isc gpl3Plus ];
    maintainers = with maintainers; [ liarokapisv kashw2 ];
    platforms = platforms.all;
  };
})
