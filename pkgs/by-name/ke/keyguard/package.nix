{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  binutils,
  fakeroot,
  jdk17,
  fontconfig,
  autoPatchelfHook,
  libXinerama,
  libXrandr,
  file,
  gtk3,
  glib,
  cups,
  lcms2,
  alsa-lib,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  gradleBuildTask = ":desktopApp:createDistributable";
  gradleUpdateTask = gradleBuildTask;
  desktopItems = [
    (makeDesktopItem {
      name = "Keyguard";
      exec = "Keyguard";
      icon = "Keyguard";
      comment = "Keyguard";
      desktopName = "Keyguard";
    })
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "keyguard";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "AChep";
    repo = "keyguard-app";
    rev = "8f6d527a42f13c6bdcee2ca3f133dd19751fc37a";
    hash = "sha256-llr+792hzifV5vP0e7AKWhW3OtYcyAhzXPR45Do62ug=";
  };

  inherit gradleBuildTask gradleUpdateTask desktopItems;

  nativeBuildInputs = [
    gradle
    binutils
    fakeroot
    jdk17
    autoPatchelfHook
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  doCheck = false;

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk17}" ];

  env.JAVA_HOME = jdk17;

  buildInputs = [
    fontconfig
    libXinerama
    libXrandr
    file
    gtk3
    glib
    cups
    lcms2
    alsa-lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -a ./desktopApp/build/compose/binaries/main/app/*/* $out/
    install -Dm0644 $out/lib/Keyguard.png $out/share/pixmaps/Keyguard.png

    runHook postInstall
  '';

  meta = {
    description = "Alternative client for the Bitwarden platform, created to provide the best user experience possible";
    homepage = "https://github.com/AChep/keyguard-app";
    mainProgram = "Keyguard";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aucub ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
