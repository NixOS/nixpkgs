{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  makeBinaryWrapper,
  openjdk,
  wrapGAppsHook3,
  xorg,
}:

let
  jdk = openjdk.override {
    enableJavaFX = true;
  };

in
stdenv.mkDerivation rec {
  pname = "keyboard-layout-editor";
  version = "0-unstable-2019-05-14";

  src = fetchFromGitHub {
    owner = "vgresak";
    repo = "keyboard-layout-editor";
    rev = "308c62ac4bb9ad25429f4d09c0aaa9f72d4194c9";
    hash = "sha256-ieXHgXAdC1xVJWXwpf9sQ9FaSLeaJfd+Rr7uD8blwHE=";
  };

  patches = [ ./fix-build-gradle.patch ];

  nativeBuildInputs = [
    gradle_8
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  gradleUpdateScript = ''
    runHook preBuild

    gradle nixDownloadDeps -Dos.family=linux -Dos.arch=amd64
    gradle nixDownloadDeps -Dos.family=linux -Dos.arch=aarch64
    gradle nixDownloadDeps -Dos.name='mac os x' -Dos.arch=amd64
    gradle nixDownloadDeps -Dos.name='mac os x' -Dos.arch=aarch64
  '';

  mitmCache = gradle_8.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "fatJar";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp build/libs/keyboard-layout-editor-all-1.0-SNAPSHOT.jar $out/share/java/keyboard-layout-editor.jar
    mkdir -p $out/bin
    makeWrapper ${lib.getExe jdk} $out/bin/keyboard-layout-editor \
      --prefix PATH : ${lib.makeBinPath [ xorg.xkbcomp ]} \
      --add-flags "--add-opens=javafx.graphics/com.sun.prism=ALL-UNNAMED" \
      --add-flags "--add-opens=javafx.graphics/com.sun.javafx.font=ALL-UNNAMED" \
      --add-flags "--add-opens=javafx.graphics/com.sun.javafx.tk=ALL-UNNAMED" \
      --add-flags "-cp $out/share/java/keyboard-layout-editor.jar cz.gresak.keyboardeditor.Main" \
      ''${gappsWrapperArgs[@]}

    runHook postInstall
  '';

  meta = {
    description = "Keyboard layout editor for XKB";
    homepage = "https://github.com/vgresak/keyboard-layout-editor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fliegendewurst ];
    mainProgram = "keyboard-layout-editor";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
