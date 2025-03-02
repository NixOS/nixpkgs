{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  jdk23,
  gradle,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  pname = "recaf";
  jdk = jdk23.override { enableJavaFX = true; };
in
stdenv.mkDerivation {
  inherit pname;
  version = "4.0-unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "Col-E";
    repo = "Recaf";
    rev = "483b8004251e5c654090d2315af30913d724a083";
    hash = "sha256-OKz9KSl1g0ddLm38f6E6Ee9X0Q53hngPZPFDtramunQ=";
    #Required for build info
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    git
    jdk
    gradle
    makeWrapper
    copyDesktopItems
  ];

  patches = [
    ./wrap-javafx.patch
    ./use-java-23.patch
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  # This is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk}" ];

  gradleBuildTask = "recaf-ui:shadowJar";

  installPhase = ''
    runHook preInstall

    install -D recaf-ui/build/libs/recaf-ui-*-all.jar $out/share/recaf/recaf.jar
    install -D recaf-ui/src/main/resources/icons/logo.png $out/share/icons/hicolor/128x128/apps/recaf.png

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    makeWrapper ${lib.getExe jdk} $out/bin/recaf \
      --add-flags "-jar $out/share/recaf/recaf.jar"

    runHook postFixup
  '';

  gradleUpdateScript = ''
    runHook preBuild

    for platform in linux linux-aarch64 osx osx-aarch64; do
      FX_PLATFORM=$platform gradle nixDownloadDeps
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "recaf";
      exec = "recaf";
      icon = "recaf";
      comment = "The modern Java bytecode editor";
      desktopName = "Recaf";
      mimeTypes = [
        "application/java"
        "application/java-vm"
        "application/java-archive"
      ];
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Moderan Java bytecode editor";
    homepage = "https://github.com/Col-E/Recaf";
    platforms = jdk.meta.platforms;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    mainProgram = "recaf";
  };
}
