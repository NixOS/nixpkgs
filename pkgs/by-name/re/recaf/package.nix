{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  jdk22,
  gradle,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  pname = "recaf";
  version = "4.0.0-SNAPSHOT";

  jdk = jdk22.override {
    enableJavaFX = true;
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Col-E";
    repo = "Recaf";
    rev = "de2138caef7255fc941ccec8b58b0345310ad9db";
    hash = "sha256-fYXcaw2V+5jXdk6reX23eiNfPgTrRoT6jmSxRf6stPw=";
  };

  nativeBuildInputs = [
    git
    jdk
    gradle
    makeWrapper
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk}"
    "-Dskip_jfx_bundle=1"
  ];

  gradleBuildTask = "recaf-ui:shadowJar";

  installPhase = ''
    runHook preInstall

    install -D recaf-ui/build/libs/recaf-ui-${version}-all.jar $out/share/recaf/recaf.jar
    install -D recaf-ui/src/main/resources/icons/logo.png $out/share/icons/hicolor/128x128/apps/recaf.png

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    makeWrapper ${jdk}/bin/java $out/bin/recaf \
      --add-flags "-jar $out/share/recaf/recaf.jar"

    runHook postFixup
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
      categories = [
        "Development"
        "Utility"
      ];
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
  };
}
