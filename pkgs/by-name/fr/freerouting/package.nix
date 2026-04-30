{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  makeDesktopItem,
  jdk25,
  gradle,
  copyDesktopItems,
  jre25_minimal,
}:

let
  jre = jre25_minimal.override {
    modules = [
      "java.base"
      "java.compiler"
      "java.desktop"
      "java.instrument"
      "java.naming"
      "java.net.http"
      "java.rmi"
      "java.scripting"
      "java.security.jgss"
      "java.sql"
      "jdk.attach"
      "jdk.jdi"
      "jdk.management"
      "jdk.unsupported"
    ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freerouting";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "freerouting";
    repo = "freerouting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bIts0ORxw9GDKRP78k0YnrfUqBliyf8v3gK/WtfNRgw=";
  };

  gradleBuildTask = "dist";

  nativeBuildInputs = [
    makeBinaryWrapper
    jdk25
    gradle
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "--no-configuration-cache" ];

  postPatch = ''
    # The rewrite-gradle plugin breaks the nixDownloadDeps task injected by fetchDeps
    substituteInPlace build.gradle \
      --replace-fail "rewrite 'org.openrewrite.recipe:rewrite-gradle:2.3.0'" ""
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/freerouting}
    cp build/dist/freerouting-executable.jar $out/share/freerouting

    makeWrapper ${lib.getExe jre} $out/bin/freerouting \
      --add-flags "-jar $out/share/freerouting/freerouting-executable.jar"

    install -Dm644 ${finalAttrs.src}/assets/icon/freerouting_icon_256x256_v3.png \
      $out/share/icons/hicolor/256x256/apps/freerouting.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = "freerouting";
      icon = "freerouting";
      desktopName = "Freerouting";
      comment = finalAttrs.meta.description;
      categories = [
        "Electricity"
        "Engineering"
        "Graphics"
      ];
    })
  ];

  meta = {
    description = "Advanced PCB auto-router";
    homepage = "https://www.freerouting.org";
    changelog = "https://github.com/freerouting/freerouting/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      Freerouting is an advanced autorouter for all PCB programs that support
      the standard Specctra or Electra DSN interface. '';
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      srounce
      Misaka13514
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "freerouting";
  };
})
