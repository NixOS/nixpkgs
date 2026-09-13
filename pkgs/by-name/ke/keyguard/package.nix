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
  jetbrains, # https://github.com/AChep/keyguard-app/commit/e0627190abfd94d9367dec42c39c991d378c3660
  lcms2,
  libglvnd,
  libxinerama,
  libxrandr,
  stripJavaArchivesHook,
  writeText,
}:

let
  gradle = gradle_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "keyguard";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "AChep";
    repo = "keyguard-app";
    tag = "r20260905.2";
    hash = "sha256-1F35vqG1pFMvsDm8I9f91yS4Oi+YgzukqJtc138hsHQ=";
  };

  postPatch = ''
    substituteInPlace desktopApp/build.gradle.kts \
      --replace-fail 'dependsOn(prepareBundledAppResources)' ""

    # The Compose repository must not shadow dependencies published by Maven Central.
    substituteInPlace settings.gradle \
      --replace-fail \
        'maven { url "https://maven.pkg.jetbrains.space/public/p/compose/dev" }' \
        'maven {
          url "https://maven.pkg.jetbrains.space/public/p/compose/dev"
          content {
            includeGroupByRegex "org[.]jetbrains[.]compose([.].*)?"
            includeGroupByRegex "org[.]jetbrains[.]androidx([.].*)?"
          }
        }'
    substituteInPlace buildPlugins/settings.gradle.kts \
      --replace-fail \
        'maven(url = "https://maven.pkg.jetbrains.space/public/p/compose/dev")' \
        'maven(url = "https://maven.pkg.jetbrains.space/public/p/compose/dev") {
          content {
            includeGroupByRegex("org[.]jetbrains[.]compose([.].*)?")
            includeGroupByRegex("org[.]jetbrains[.]androidx([.].*)?")
          }
        }'
  '';

  preBuild = ''
    export ANDROID_USER_HOME="$TMPDIR/.android"
    mkdir -p "$ANDROID_USER_HOME"
  '';

  gradleBuildTask = ":desktopApp:createReleaseDistributable";

  gradleUpdateTask = finalAttrs.gradleBuildTask;

  # fetch dependencies for all supported Linux architectures
  postGradleUpdate = ''
    gradle :desktopApp:nixDownloadDeps -Dos.family=linux -Dos.arch=amd64
    gradle :desktopApp:nixDownloadDeps -Dos.family=linux -Dos.arch=aarch64
  '';

  gradleInitScript = writeText "empty-init-script.gradle" "";

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gradle
    jetbrains.jdk-no-jcef-21
    stripJavaArchivesHook
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

    # fail if Compose changes the app resources path expected below
    grep -Fqx \
      'java-options=-Dcompose.application.resources.dir=$APPDIR/resources' \
      $out/lib/app/Keyguard.cfg

    install -D --mode=0644 $out/lib/Keyguard.png $out/share/icons/hicolor/512x512/apps/keyguard.png

    # `prepareBundledAppResources` is patched out, so stage these under the
    # names the app expects
    install -D --mode=0755 ${finalAttrs.passthru.sshAgent}/bin/keyguard-ssh-agent \
      $out/lib/app/resources/keyguard-ssh-agent
    install -D --mode=0755 ${finalAttrs.passthru.gpgAgent}/bin/keyguard-gpg-agent \
      $out/lib/app/resources/keyguard-gpg-agent
    install -D --mode=0755 ${finalAttrs.passthru.libNative}/lib/libkeyguard.so \
      $out/lib/app/resources/keyguard-lib
    install -D --mode=0755 ${finalAttrs.passthru.crypto}/lib/libkeyguard_crypto_jni.so \
      $out/lib/app/resources/libkeyguard_crypto_jni.so
    install -D --mode=0755 ${finalAttrs.passthru.io}/lib/libkeyguard_io_jni.so \
      $out/lib/app/resources/libkeyguard_io_jni.so

    install -Dm444 -t $out/share/applications/ desktopApp/flatpak/*.desktop
    install -Dm444 desktopApp/flatpak/icon.svg $out/share/icons/hicolor/scalable/apps/com.artemchep.keyguard.svg
    install -Dm444 -t $out/share/metainfo/ desktopApp/flatpak/*.metainfo.xml

    runHook postInstall
  '';

  passthru = {
    crypto = callPackage ./crypto.nix { inherit (finalAttrs) src version; };
    gpgAgent = callPackage ./gpg-agent.nix { inherit (finalAttrs) src version; };
    io = callPackage ./io.nix { inherit (finalAttrs) src version; };
    libNative = callPackage ./lib-native.nix { inherit (finalAttrs) src version; };
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
      fromSource # Keyguard and bundled helpers
      binaryBytecode # mitm cache
      binaryNativeCode # JNA and SQLite JDBC natives
    ];
    platforms = lib.platforms.linux;
  };
})
