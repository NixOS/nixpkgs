{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jdk17,
  fontconfig,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "keyguard";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "AChep";
    repo = "keyguard-app";
    tag = "r20250530";
    hash = "sha256-FTDZ4ztFv+pcyupI+tHr+VLrENSN6hqs13i1KJmreAM=";
  };

  postPatch = ''
    substituteInPlace desktopLibJvm/build.gradle.kts \
      --replace-fail 'resources.srcDir(rootDir.resolve("desktopLibNative/build/bin/universal"))' "" \
      --replace-fail 'resourcesTask.dependsOn(":desktopLibNative:''${Tasks.compileNativeUniversal}")' ""
  '';

  gradleBuildTask = ":desktopApp:createDistributable";

  gradleUpdateTask = finalAttrs.gradleBuildTask;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  env.JAVA_HOME = jdk17;

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk17}" ];

  nativeBuildInputs = [
    gradle
    jdk17
    copyDesktopItems
  ];

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

  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "keyguard";
      exec = "Keyguard";
      icon = "keyguard";
      comment = "Keyguard";
      desktopName = "Keyguard";
    })
  ];

  installPhase = ''
    runHook preInstall

    cp -r desktopApp/build/compose/binaries/main/app/Keyguard $out
    install -Dm0644 $out/lib/Keyguard.png $out/share/pixmaps/keyguard.png

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Alternative client for the Bitwarden platform, created to provide the best user experience possible";
    homepage = "https://github.com/AChep/keyguard-app";
    mainProgram = "Keyguard";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    platforms = lib.platforms.linux;
  };
})
