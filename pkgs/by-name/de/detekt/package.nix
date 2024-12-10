{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "detekt";
  version = "1.23.7";

  jarfilename = "detekt-${finalAttrs.version}-executable.jar";

  src = fetchurl {
    url = "https://github.com/detekt/detekt/releases/download/v${finalAttrs.version}/detekt-cli-${finalAttrs.version}-all.jar";
    sha256 = "sha256-hL7e0oMBLLKzi8rvSZZFL81gadLpynS1Dqp54K0hiX4=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D "$src" "$out/share/java/${finalAttrs.jarfilename}"

    makeWrapper ${jre_headless}/bin/java $out/bin/detekt \
      --add-flags "-jar $out/share/java/${finalAttrs.jarfilename}"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "Static code analysis for Kotlin";
    mainProgram = "detekt";
    homepage = "https://detekt.dev/";
    license = licenses.asl20;
    platforms = jre_headless.meta.platforms;
    maintainers = with maintainers; [ mdr ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
})
