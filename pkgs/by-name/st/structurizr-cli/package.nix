{
  lib,
  stdenv,
  fetchzip,
  makeBinaryWrapper,
  jre,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "structurizr-cli";
  version = "2025.05.28";

  src = fetchzip {
    url = "https://github.com/structurizr/cli/releases/download/v${finalAttrs.version}/structurizr-cli.zip";
    hash = "sha256-UYqUZydjsAoy5be/UhAyX/7OvLq8pXA6STwbEnCG7CU=";
    stripRoot = false;
  };

  strictDeps = true;
  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    # Create folder structure
    mkdir -p $out/bin
    # Copy all jars
    cp -r $src/. $out/

    # Find the names of all jars
    jars=$(find $out/lib -name "*.jar" | tr '\n' ':')
    jars=$(echo $jars | sed 's/:$//')

    # Create custom wrapper, since we want to inject our own java
    makeBinaryWrapper ${jre}/bin/java $out/bin/structurizr-cli \
      --add-flags "-cp $jars com.structurizr.cli.StructurizrCliApplication"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Structurizr CLI for publishing C4 architecture diagrams and models";
    homepage = "https://github.com/structurizr/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhemeryck ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.all;
    mainProgram = "structurizr-cli";
  };
})
