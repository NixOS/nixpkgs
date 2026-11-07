{
  fetchurl,
  jdk21_headless,
  lib,
  makeWrapper,
  stdenvNoCC,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ijhttp";
  version = "261.25134.95";

  src = fetchurl {
    url = "https://download.jetbrains.com/resources/intellij/http-client/${finalAttrs.version}/intellij-http-client.zip";
    hash = "sha256-RlbpweLHmPvn/Xjtj8EkvAceu0bgJ3DhmKViaJ2jLJ0=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv lib $out/lib
    install -Dm755 ijhttp $out/lib/ijhttp
    makeWrapper $out/lib/ijhttp $out/bin/ijhttp \
      --set JAVA_HOME ${jdk21_headless.home}

    runHook postInstall
  '';

  meta = {
    description = "Run HTTP requests from a terminal, e.g. for HTTP request testing";
    homepage = "https://www.jetbrains.com/help/idea/http-client-cli.html";
    license = lib.licenses.unfree;
    mainProgram = "ijhttp";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
