# SPDX-FileCopyrightText: 2023-2025 Balthazar Patiachvili <ratcornu+programmation@skaven.org>
# SPDX-FileCopyrightText: 2025 Hana Kretzer <hanakretzer@gmail.com>
#
# SPDX-License-Identifier: MIT
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  gradle_8,
  jdk21_headless,
  suwayomi-webui,
  nix-update-script,
  nixosTests,
  electron,

  jdk ? jdk21_headless,
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

  postPatch = ''
    sed -i -E \
      -e 's/v[0-9]\.[0-9]{1,2}\.\$\{getCommitCount\(\)\}/v${finalAttrs.version}/g' \
      -e 's/r[0-9]{4,5}/r${webui.revision}/g' \
      -e 's/r\$\{getCommitCount\(\)\}/r${lib.elemAt (lib.splitString "." finalAttrs.version) 2}/g' \
      buildSrc/src/main/kotlin/Constants.kt

    install -m644 ${webui}/share/WebUI.zip server/src/main/resources
  '';

  nativeBuildInputs = [
    makeWrapper
    gradle_8
  ];

  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-x"
    ":server:processResources"

    "-Dorg.gradle.daemon=false"
    "-Dorg.gradle.java.home=${jdk}"
    "-Dorg.gradle.jvmargs=-Xmx5120m"

    "-Dkotlin.incremental=false"
    "-Dkotlin.compiler.execution.strategy=in-process"
  ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/suwayomi-server}
    cp server/build/Suwayomi-Server-v${finalAttrs.version}.jar $out/share/suwayomi-server

    makeWrapper ${lib.getExe jdk} $out/bin/tachidesk-server \
      ${lib.optionalString asApplication ''
        --add-flags "-Dsuwayomi.tachidesk.config.server.webUIInterface=electron" \
        --add-flags '-Dsuwayomi.tachidesk.config.server.electronPath="${lib.getExe electron}"' \
      ''} \
      ${
        lib.optionalString (!asApplication) ''
          --add-flags "-Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false" \
        ''
      } \
      --add-flags "-jar $out/share/suwayomi-server/Suwayomi-Server-v${finalAttrs.version}.jar"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "mitmCache"
      ];
    };

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
      ratcornu
      nanoyaki
    ];
    mainProgram = "tachidesk-server";
  };
})
