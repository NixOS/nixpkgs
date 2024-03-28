{ stdenv
, fetchzip
, bash
, jdk17
, lib
, makeWrapper
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  name = "dita-ot";
  version = "4.2.1";

  nativeBuildInputs = [
    makeWrapper
  ];
  buildInputs = [
    bash
    jdk17
  ];

  src = fetchzip {
    url = "https://github.com/dita-ot/dita-ot/releases/download/${finalAttrs.version}/dita-ot-${finalAttrs.version}.zip";
    hash = "sha256-PtscKsQwW1uBu0OfVHi7/d9JujGx12nZT+W3uMPQQWc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/$name/
    cp -r $src/* $out/$name/

    makeWrapper "$out/$name/bin/dita" "$out/bin/dita" \
      --prefix PATH : "${lib.makeBinPath [ jdk17 ]}" \
      --set-default JDK_HOME "$jdk17" \
      --set-default JAVA_HOME "$jdk17"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    homepage = "https://dita-ot.org";
    changelog = "https://www.dita-ot.org/dev/release-notes/#v${finalAttrs.version}";
    description = "The open-source publishing engine for content authored in the Darwin Information Typing Architecture";
    license = lib.licenses.asl20;
    mainProgram = "dita";
    platforms = jdk17.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ robertr ];
  };
})
