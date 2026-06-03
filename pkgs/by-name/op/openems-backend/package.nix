{
  lib,
  stdenv,
  gradle_9,
  jre,
  makeWrapper,
  openems-edge,
  writableTmpDirAsHomeHook,
  ...
}:
stdenv.mkDerivation (finalAttrs: {

  pname = "openems-backend";

  inherit (openems-edge)
    src
    version
    mitmCache
    ;

  strictDeps = true;
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    gradle_9
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  gradleBuildTask = "buildBackend";

  installPhase = ''
    runHook preInstall

    install -Dm644 build/openems-backend.jar -t $out/share/openems-backend
    mkdir -p $out/bin
    makeWrapper ${lib.getExe jre} $out/bin/openems-backend \
      --add-flags "\$JAVA_OPTS" \
      --add-flags "-jar $out/share/openems-backend/openems-backend.jar"

    runHook postInstall
  '';

  meta = {
    description = "Open energy management system (backend)";
    longDescription = "Connects decentralized openems-edge systems and provides aggregation, monitoring and control)";
    license = lib.licenses.epl20;
    homepage = "https://openems.io/";
    changelog = "https://github.com/openems/openems/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ mrcjkb ];
    mainProgram = "openems-backend";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };

})
