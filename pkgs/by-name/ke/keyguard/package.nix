{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  jdk21,
  fontconfig,
  libxinerama,
  libxrandr,
  file,
  gtk3,
  glib,
  cups,
  lcms2,
  alsa-lib,
  makeDesktopItem,
  copyDesktopItems,
  libglvnd,
  autoPatchelfHook,
  writeText,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keyguard";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "AChep";
    repo = "keyguard-app";
    tag = "r20260228.1";
    hash = "sha256-J8rP+DnbX0ktCiq8W9UsE3tM2V1apQrSLed7sq1gP6w=";
  };

  postPatch = ''
    substituteInPlace desktopApp/build.gradle.kts \
      --replace-fail 'dependsOn(prepareBundledAppResources)' ""
  '';

  gradleBuildTask = ":desktopApp:createReleaseDistributable";

  gradleUpdateTask = finalAttrs.gradleBuildTask;

  gradleInitScript = writeText "empty-init-script.gradle" "";

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  env.JAVA_HOME = jdk21;

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk21}" ];

  nativeBuildInputs = [
    gradle_9
    jdk21
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    fontconfig
    libxinerama
    libxrandr
    file
    gtk3
    glib
    cups
    lcms2
    alsa-lib
    libglvnd
  ];

  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "keyguard";
      exec = "Keyguard";
      icon = "keyguard";
      desktopName = "Keyguard";
    })
  ];

  installPhase = ''
    runHook preInstall

    cp --recursive desktopApp/build/compose/binaries/main-release/app/Keyguard $out
    install -D --mode=0644 $out/lib/Keyguard.png $out/share/icons/hicolor/512x512/apps/keyguard.png

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Alternative client for the Bitwarden platform, created to provide the best user experience possible";
    homepage = "https://github.com/AChep/keyguard-app";
    mainProgram = "Keyguard";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ilkecan ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    platforms = lib.platforms.linux;
  };
})
