{
  lib,
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  callPackage,
  cups,
  fetchFromGitHub,
  file,
  fontconfig,
  glib,
  gradle_9,
  gtk3,
  jdk21,
  lcms2,
  libglvnd,
  libxinerama,
  libxrandr,
  writeText,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keyguard";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "AChep";
    repo = "keyguard-app";
    tag = "r20260313.1";
    hash = "sha256-In40E185uU6Noq6OoQ1TP4x/P3X369QwjqwXNRvvuA0=";
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

  gradleFlags = [ "-Dorg.gradle.java.home=${finalAttrs.env.JAVA_HOME}" ];

  nativeBuildInputs = [
    gradle_9
    jdk21
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

  installPhase = ''
    runHook preInstall

    cp --recursive desktopApp/build/compose/binaries/main-release/app/Keyguard $out
    install -Dm755 ${finalAttrs.passthru.sshAgent}/bin/keyguard-ssh-agent \
      $out/lib/app/resources/keyguard-ssh-agent

    install -Dm444 -t $out/share/applications/ desktopApp/flatpak/*.desktop
    install -Dm444 desktopApp/flatpak/icon.svg $out/share/icons/hicolor/scalable/apps/com.artemchep.keyguard.svg
    install -Dm444 -t $out/share/metainfo/ desktopApp/flatpak/*.metainfo.xml

    runHook postInstall
  '';

  passthru = {
    sshAgent = callPackage ./ssh-agent.nix { inherit (finalAttrs) src version; };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Alternative client for the Bitwarden platform, created to provide the best user experience possible";
    homepage = "https://github.com/AChep/keyguard-app";
    changelog = "https://github.com/AChep/keyguard-app/releases/tag/${finalAttrs.src.tag}";
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
