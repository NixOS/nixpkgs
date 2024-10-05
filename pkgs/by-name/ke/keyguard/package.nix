{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  binutils,
  dpkg,
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
}:
let
  gradleBuildTask = ":desktopApp:packageDeb";
  gradleUpdateTask = gradleBuildTask;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "keyguard";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "AChep";
    repo = "keyguard-app";
    rev = "16e02dee823184058d43a706ed6a34d03e29680b";
    hash = "sha256-jiQnLMGUdM2UcW4c/zz2XqEVix5B68wEvpPtVAnVfEI=";
  };

  inherit gradleBuildTask gradleUpdateTask;

  nativeBuildInputs = [
    gradle
    binutils
    dpkg
    fakeroot
    jdk17
    autoPatchelfHook
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
    dpkg -x ./desktopApp/build/compose/binaries/main/deb/*.deb $out
    mv $out/opt/keyguard/* -t $out/
    rm -r $out/opt
    install -Dm0644 $out/lib/*-Keyguard.desktop $out/share/applications/Keyguard.desktop
    substituteInPlace $out/share/applications/Keyguard.desktop \
      --replace-fail 'Exec=/opt/keyguard/bin/Keyguard' 'Exec=Keyguard' \
      --replace-fail 'Icon=/opt/keyguard/lib/Keyguard.png' 'Icon=Keyguard'
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
