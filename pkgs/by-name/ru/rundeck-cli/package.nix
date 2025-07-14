{
  lib,
  stdenv,
  fetchurl,
  makeBinaryWrapper,
  jre11_minimal,
  jdk11_headless,
  versionCheckHook,
  nix-update-script,
}:
let
  jre11_minimal_headless = jre11_minimal.override {
    jdk = jdk11_headless;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rundeck-cli";
  version = "2.0.9";

  src = fetchurl {
    url = "https://github.com/rundeck/rundeck-cli/releases/download/v${finalAttrs.version}/rundeck-cli-${finalAttrs.version}-all.jar";
    hash = "sha256-c6QAgwyRCtoOlS7DEmjyK3BwHV122bilL6H+Hzrv2dQ=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ jre11_minimal_headless ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rundeck-cli
    cp $src $out/share/rundeck-cli/rundeck-cli.jar

    mkdir -p $out/bin
    makeWrapper ${lib.getExe jre11_minimal_headless} $out/bin/rd \
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
