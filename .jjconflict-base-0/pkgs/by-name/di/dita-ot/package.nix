{
  stdenv,
  fetchzip,
  openjdk17,
  lib,
  makeWrapper,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dita-ot";
  version = "4.2.3";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ openjdk17 ];

  src = fetchzip {
    url = "https://github.com/dita-ot/dita-ot/releases/download/${finalAttrs.version}/dita-ot-${finalAttrs.version}.zip";
    hash = "sha256-siHz81OuKVF77NsDpldAhq7YxzBFvo9RwGPe/mqkquQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/dita-ot/
    cp -r $src/* $out/share/dita-ot/

    makeWrapper "$out/share/dita-ot/bin/dita" "$out/bin/dita" \
      --prefix PATH : "${lib.makeBinPath [ openjdk17 ]}" \
      --set-default JDK_HOME "${openjdk17.home}" \
      --set-default JAVA_HOME "${openjdk17.home}"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    homepage = "https://dita-ot.org";
    changelog = "https://www.dita-ot.org/dev/release-notes/#v${finalAttrs.version}";
    description = "The open-source publishing engine for content authored in the Darwin Information Typing Architecture";
    license = lib.licenses.asl20;
    mainProgram = "dita";
    platforms = openjdk17.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ robertrichter ];
  };
})
