{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk21_headless,
  nixosTests,
}:

let
  jdk = jdk21_headless;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "suwayomi-server";
  version = "2.1.1867";

  src = fetchurl {
    url = "https://github.com/Suwayomi/Suwayomi-Server/releases/download/v${finalAttrs.version}/Suwayomi-Server-v${finalAttrs.version}.jar";
    hash = "sha256-UeMHwlgeThoAKZGrPjp3UDyLB0xCaVmHqYSnOC0Kxa8=";
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
    description = "Free and open source manga reader server that runs extensions built for Mihon (Tachiyomi)";
    longDescription = ''
      Suwayomi is an independent Mihon (Tachiyomi) compatible software and is not a Fork of Mihon (Tachiyomi).

      Suwayomi-Server is as multi-platform as you can get. Any platform that runs java and/or has a modern browser can run it. This includes Windows, Linux, macOS, chrome OS, etc.
    '';
    homepage = "https://github.com/Suwayomi/Suwayomi-Server";
    downloadPage = "https://github.com/Suwayomi/Suwayomi-Server/releases";
    changelog = "https://github.com/Suwayomi/Suwayomi-Server/releases/tag/v${finalAttrs.version}";
    license = licenses.mpl20;
    platforms = jdk.meta.platforms;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
    maintainers = with maintainers; [ ratcornu ];
    mainProgram = "tachidesk-server";
  };
})
