# SPDX-FileCopyrightText: 2023-2026 Balthazar Patiachvili <ratcornu+programmation@skaven.org>
# SPDX-FileCopyrightText: 2025-2026 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: MIT
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch2,
  zip,
  makeWrapper,
  gradle_8,
  copyDesktopItems,
  glib,
  libappindicator,
  jdk21,
  suwayomi-webui,
  _experimental-update-script-combinators,
  nix-update-script,
  writeShellScript,
  nixosTests,
  electron,
  makeDesktopItem,

  jdk ? jdk21,
  webui ? suwayomi-webui,
  asApplication ? false,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "suwayomi-server";
  version = "2.1.1867";

  src = fetchFromGitHub {
    owner = "Suwayomi";
    repo = "Suwayomi-Server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ppDkh7ALLi6U6uS7b0H4DYvB7l4/EHTj1eLV7nYOceI=";
  };

  patches = [
    # Fixes compilation error caused by a newer android jar
    # than what's included in the github release binary
    (fetchpatch2 {
      url = "https://github.com/Suwayomi/Suwayomi-Server/commit/5be4d2a1044b0eaac8dba8fdf060ce1c4b4381e9.patch";
      hash = "sha256-cLFHQQBAALyEVdfVOg5g9ZRI9k4nbB0Lhvq7RJ03hrc=";
    })
    ./disable-download.patch
  ];

  postPatch = ''
    echo 'const val MainClass = "suwayomi.tachidesk.MainKt"
    val getTachideskVersion = { "v${finalAttrs.version}" }
    val webUIRevisionTag = "r${webui.revision}"
    val getTachideskRevision = { "r${lib.versions.patch finalAttrs.version}" }
    ' > buildSrc/src/main/kotlin/Constants.kt

    zip -9 -r server/src/main/resources/WebUI.zip ${webui}
  '';

  nativeBuildInputs = [
    zip
    makeWrapper
    gradle_8
  ]
  ++ lib.optional asApplication copyDesktopItems;

  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk}"
    "-Dorg.gradle.jvmargs=-Xmx2G"
  ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/suwayomi-server,share/icons/hicolor/128x128/apps}
    cp server/build/Suwayomi-Server-v${finalAttrs.version}.jar $out/share/suwayomi-server

    # Use nixpkgs suwayomi-webui and disable auto download and update
    makeWrapper ${lib.getExe jdk} $out/bin/tachidesk-server \
      --add-flags "-Dsuwayomi.tachidesk.config.server.webUIFlavor=WebUI" \
      --add-flags "-Dsuwayomi.tachidesk.config.server.webUIChannel=BUNDLED" \
      --add-flags "-Dsuwayomi.tachidesk.config.server.webUIUpdateCheckInterval=0" \
  ''
  + lib.optionalString asApplication ''
    --prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        libappindicator
        glib
      ]
    }" \
    --add-flags "-Dsuwayomi.tachidesk.config.server.webUIInterface=electron" \
    --add-flags '-Dsuwayomi.tachidesk.config.server.electronPath="${lib.getExe electron}"' \
  ''
  + lib.optionalString (!asApplication) ''
    --add-flags "-Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false" \
    --add-flags "-Dsuwayomi.tachidesk.config.server.systemTrayEnabled=false" \
  ''
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
        name = pname;
        desktopName = "Suwayomi Server";
        comment = "Free and open source manga reader";
        exec = meta.mainProgram;
        terminal = false;
        icon = pname;
        startupWMClass = pname;
        categories = [ "Utility" ];
      }
    )
  );

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (writeShellScript "update-deps.sh" ''
        $(nix-build -A suwayomi-server.mitmCache.updateScript)
      '')
    ];

    tests = {
      suwayomi-server-with-auth = nixosTests.suwayomi-server.with-auth;
      suwayomi-server-without-auth = nixosTests.suwayomi-server.without-auth;
    };
  };

  meta = {
    description = "Free and open source manga reader server that runs extensions built for Mihon (Tachiyomi)";
    longDescription = ''
      Suwayomi is an independent Mihon (Tachiyomi) compatible software and is not a Fork of Mihon (Tachiyomi).

      Suwayomi-Server is as multi-platform as you can get.
      Any platform that runs java and/or has a modern browser can run it.
      This includes Windows, Linux, macOS, chrome OS, etc.
    '';
    homepage = "https://github.com/Suwayomi/Suwayomi-Server";
    downloadPage = "https://github.com/Suwayomi/Suwayomi-Server/releases";
    changelog = "https://github.com/Suwayomi/Suwayomi-Server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    inherit (jdk.meta) platforms;
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
