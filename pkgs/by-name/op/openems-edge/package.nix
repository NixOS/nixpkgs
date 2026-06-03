{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  jre,
  makeWrapper,
  bash,
  writableTmpDirAsHomeHook,
  ...
}:
stdenv.mkDerivation (finalAttrs: {

  pname = "openems-edge";
  version = "2026.5.0";

  src = fetchFromGitHub {
    owner = "OpenEMS";
    repo = "openems";
    tag = "${finalAttrs.version}";
    hash = "sha256-BQzkjq+rvYuPGthU1okgAO89FRIU3x+8jYW20hbGuLk=";
  };

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  strictDeps = true;
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    gradle_9
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  gradleBuildTask = "buildEdge";

  postPatch = ''
    # This directory contains PDF files that causes a gradle build failure,
    # likely due to characters in the file names.
    rm -r io.openems.edge.*/doc/

    substituteInPlace io.openems.edge.core/src/io/openems/edge/core/host/Bash.java \
      --replace-fail '/bin/bash' '${bash}/bin/bash'

    substituteInPlace io.openems.edge.core/src/io/openems/edge/core/host/OperatingSystemDebianSystemd.java \
      --replace-fail '/usr/bin/systemctl' 'systemctl'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/openems-edge.jar -t $out/share/openems-edge
    mkdir -p $out/bin
    makeWrapper ${lib.getExe jre} $out/bin/openems-edge \
      --add-flags "\$JAVA_OPTS" \
      --add-flags "-jar $out/share/openems-edge/openems-edge.jar"

    runHook postInstall
  '';

  meta = {
    description = "Open energy management system (IoT edge device runtime)";
    license = lib.licenses.epl20;
    homepage = "https://openems.io/";
    changelog = "https://github.com/openems/openems/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ mrcjkb ];
    mainProgram = "openems-edge";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };

})
