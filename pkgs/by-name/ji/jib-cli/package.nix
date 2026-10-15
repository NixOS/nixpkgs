{
  stdenv,
  fetchzip,
  lib,
  makeWrapper,
  jre,
  stripJavaArchivesHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jib-cli";
  version = "0.13.0";

  src = fetchzip {
    url = "https://github.com/GoogleContainerTools/jib/releases/download/v${finalAttrs.version}-cli/jib-jre-${finalAttrs.version}.zip";
    hash = "sha256-3/wKpwVHVBU86GJfR4YGM5ba8pOOfLL+fKU7zwwU+Qc=";
  };

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  buildInputs = [ jre ];

  dontBuild = true;
  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/jib";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r lib $out/
    jarPaths=$(find $out/lib -name '*.jar' | tr '\n' ':' | sed 's/:$//')
    makeWrapper ${jre}/bin/java $out/bin/jib \
      --add-flags "-cp \"$jarPaths\" com.google.cloud.tools.jib.cli.JibCli"
    runHook postInstall
  '';

  meta = {
    description = "Container image builder for Java using Jib CLI";
    homepage = "https://github.com/GoogleContainerTools/jib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sxmair
    ];
    mainProgram = "jib";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
