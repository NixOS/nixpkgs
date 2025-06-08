{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk11,
  unzip,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rundeck-cli";
  version = "2.0.8";

  src = fetchurl {
    url = "https://github.com/rundeck/rundeck-cli/releases/download/v${finalAttrs.version}/rundeck-cli-${finalAttrs.version}-all.jar";
    hash = "sha256-mpy4oS7zCUdt4Q+KQPrGGbw6Gzmh1Msygl+NXDmFhDw=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk11 ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rundeck-cli
    cp $src $out/share/rundeck-cli/rundeck-cli.jar

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jdk11} $out/bin/rd \
      --add-flags "-jar $out/share/rundeck-cli/rundeck-cli.jar"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/rd";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Official CLI tool for Rundeck";
    longDescription = ''
      The rd command provides command line access to the Rundeck HTTP API,
      allowing you to access and control your Rundeck server from the
      command line or shell scripts.
    '';
    homepage = "https://github.com/rundeck/rundeck-cli";
    changelog = "https://github.com/rundeck/rundeck-cli/blob/v${finalAttrs.version}/docs/changes.md";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "rd";
  };
})
