{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jdk17_headless
, nixosTests
}:

let
  jdk = jdk17_headless;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "suwayomi-server";
  version = "1.1.1";
  revision = 1535;

  src = fetchurl {
    url = "https://github.com/Suwayomi/Suwayomi-Server/releases/download/v${finalAttrs.version}/Suwayomi-Server-v${finalAttrs.version}-r${toString finalAttrs.revision}.jar";
    hash = "sha256-mPzREuH89RGhZLK+5aIPuq1gmNGc9MGG0wh4ZV5dLTg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    makeWrapper ${jdk}/bin/java $out/bin/tachidesk-server \
      --add-flags "-Dsuwayomi.tachidesk.config.server.initialOpenInBrowserEnabled=false -jar $src"

    runHook postBuild
  '';

  passthru.tests = {
    suwayomi-server-with-auth = nixosTests.suwayomi-server.with-auth;
    suwayomi-server-without-auth = nixosTests.suwayomi-server.without-auth;
  };

  meta = with lib; {
    description = "Free and open source manga reader server that runs extensions built for Tachiyomi";
    longDescription = ''
      Suwayomi is an independent Tachiyomi compatible software and is not a Fork of Tachiyomi.

      Suwayomi-Server is as multi-platform as you can get. Any platform that runs java and/or has a modern browser can run it. This includes Windows, Linux, macOS, chrome OS, etc.
    '';
    homepage = "https://github.com/Suwayomi/Suwayomi-Server";
    downloadPage = "https://github.com/Suwayomi/Suwayomi-Server/releases";
    changelog = "https://github.com/Suwayomi/Suwayomi-Server/releases/tag/v${finalAttrs.version}";
    license = licenses.mpl20;
    platforms = jdk.meta.platforms;
    maintainers = with maintainers; [ ratcornu ];
    mainProgram = "tachidesk-server";
  };
})
