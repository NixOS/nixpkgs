{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk17,
  which,
  coreutils,
  openssh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rundeck";
  version = "5.11.1-20250415";

  src = fetchurl {
    url = "https://packagecloud.io/pagerduty/rundeck/packages/java/org.rundeck/rundeck-${finalAttrs.version}.war/artifacts/rundeck-${finalAttrs.version}.war/download?distro_version_id=167";
    hash = "sha256-WOxY2GGtll+2xkSbJUKOvgsr408nIvRcEuBULcawijc=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk17 ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rundeck
    cp $src $out/share/rundeck/rundeck.war

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jdk17} $out/bin/rundeck \
      --add-flags "-jar $out/share/rundeck/rundeck.war" \
      --prefix PATH : ${
        lib.makeBinPath [
          which
          coreutils
          openssh
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Job scheduler and runbook automation";
    longDescription = ''
      Rundeck is an open source automation service with a web console,
      command line tools and a WebAPI. It lets you easily run automation tasks
      across a set of nodes.
    '';
    homepage = "https://www.rundeck.com/";
    changelog = "https://docs.rundeck.com/docs/history/";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "rundeck";
  };
})
