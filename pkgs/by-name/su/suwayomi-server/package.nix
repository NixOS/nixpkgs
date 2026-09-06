{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  copyDesktopItems,
  electron,
  jdk25_headless,
  glib,
  gradle_9,
  libappindicator,
  suwayomi-webui,
  zip,
  makeDesktopItem,
  nixosTests,

  jdk ? jdk25_headless,
  asApplication ? false,
}:

let
  gradle = gradle_9;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "suwayomi-server";
  version = "2.3.2243";

  src = fetchFromGitHub {
    owner = "Suwayomi";
    repo = "Suwayomi-Server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QKI014c7ktf6OGB1pd7gKzVGiqBGSZjpMecn2Adu3Ik=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
    zip
  ]
  ++ lib.optional asApplication copyDesktopItems;

  patches = [
    ./disable-download.patch
  ];

  postPatch = ''
    substituteInPlace buildSrc/src/main/kotlin/Constants.kt \
      --replace-fail "getCommitCount()" "${lib.versions.patch finalAttrs.version}"

    substituteInPlace server/src/main/kotlin/suwayomi/tachidesk/server/util/WebInterfaceManager.kt \
      --replace-fail "currentVersionMD5Sum == localMD5Sum" "true"

    cp -r ${suwayomi-webui} webui
    chmod -R u+xw webui
    (cd webui && zip -9 -r ../server/src/main/resources/WebUI.zip .)
    rm -rf webui
  '';

  gradleBuildTask = "shadowJar";
  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk}"
    "-Dorg.gradle.jvmargs=-Xmx2G"
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  installPhase = ''
    runHook preInstall

    ls server/build/

    mkdir -p $out/{bin,share/suwayomi-server,share/icons/hicolor/128x128/apps}
    ls $out
    cp server/build/Suwayomi-Server-v${finalAttrs.version}.jar $out/share/suwayomi-server

    # Use nixpkgs suwayomi-webui and disable auto download and update
    makeWrapper ${lib.getExe jdk} $out/bin/tachidesk-server \
      --add-flags "-Dsuwayomi.tachidesk.config.server.webUIFlavor=WebUI" \
      --add-flags "-Dsuwayomi.tachidesk.config.server.webUIChannel=BUNDLED" \
      --add-flags "-Dsuwayomi.tachidesk.config.server.webUIUpdateCheckInterval=0" \
  ''
  + (
    if asApplication then
      ''
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            libappindicator
            glib
          ]
        }" \
        --add-flags "-Dsuwayomi.tachidesk.config.server.webUIInterface=electron" \
        --add-flags '-Dsuwayomi.tachidesk.config.server.electronPath="${lib.getExe electron}"' \
      ''
    else
      ''
        --add-flags "-Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false" \
        --add-flags "-Dsuwayomi.tachidesk.config.server.systemTrayEnabled=false" \
      ''
  )
  + ''
    --add-flags "-jar $out/share/suwayomi-server/Suwayomi-Server-v${finalAttrs.version}.jar"

    install -m644 server/src/main/resources/icon/faviconlogo-128.png \
      $out/share/icons/hicolor/128x128/apps/suwayomi-server.png

    runHook postInstall
  '';

  desktopItems = lib.optional asApplication (
    makeDesktopItem (
      with finalAttrs;

      {
        name = "suwayomi-server";
        desktopName = "Suwayomi Server";
        comment = "Free and open source manga reader";
        exec = meta.mainProgram;
        terminal = false;
        icon = "suwayomi-server";
        startupWMClass = "suwayomi-server";
        categories = [ "Utility" ];
      }
    )
  );

  passthru.tests = {
    suwayomi-server-with-auth = nixosTests.suwayomi-server.with-auth;
    suwayomi-server-without-auth = nixosTests.suwayomi-server.without-auth;
  };

  meta = {
    description = "Free and open source manga reader server that runs extensions built for Mihon (Tachiyomi)";
    longDescription = ''
      Suwayomi is an independent Mihon (Tachiyomi) compatible software and is not a Fork of Mihon (Tachiyomi).

      Suwayomi-Server is as multi-platform as you can get. Any platform that runs java and/or has a modern browser can run it. This includes Windows, Linux, macOS, chrome OS, etc.
    '';
    homepage = "https://github.com/Suwayomi/Suwayomi-Server";
    downloadPage = "https://github.com/Suwayomi/Suwayomi-Server/releases";
    changelog = "https://github.com/Suwayomi/Suwayomi-Server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [
      nanoyaki
      ratcornu
    ];
    mainProgram = "tachidesk-server";
  };
})
