{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "confluent-cli";
  version = "4.82.1";
  strictDeps = true;
  __structuredAttrs = true;

  # To get the latest version:
  # curl -L https://cnfl.io/cli | sh -s -- -l | grep -v latest | sort -V | tail -n1
  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenvNoCC.hostPlatform.system}
          or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
      system = selectSystem {
        x86_64-linux = "linux_amd64";
        aarch64-linux = "linux_arm64";
        aarch64-darwin = "darwin_arm64";
      };
    in
    fetchurl {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${finalAttrs.version}/confluent_${finalAttrs.version}_${system}.tar.gz";
      hash = selectSystem {
        x86_64-linux = "sha256-848Pfq2BQFAqs5Mw37KbNslfkAdvqW91cqv/I5o23RI=";
        aarch64-linux = "sha256-njrH3fitkRIazmqDOklR/hw+vr5rEK+CjHa/4m7/tsw=";
        aarch64-darwin = "sha256-S/6oQzJkHxvFhFqpKI9HmsoPXYf9psAMPL718H90i+I=";
      };
    };

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  dontStrip = stdenvNoCC.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/doc/confluent-cli}
    cp confluent $out/bin/
    cp LICENSE $out/share/doc/confluent-cli/
    cp -r legal $out/share/doc/confluent-cli/

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = "HOME";
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Confluent CLI";
    homepage = "https://docs.confluent.io/confluent-cli/current/overview.html";
    changelog = "https://docs.confluent.io/confluent-cli/${lib.versions.majorMinor finalAttrs.version}/release-notes.html";
    mainProgram = "confluent";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [
      rguevara84
      autophagy
    ];
    # TODO: There's support for i686 systems but I do not have any such system
    # to build it locally on, it's also unfree so I cannot rely on ofborg to
    # build it. Get the list of supported system by looking at the list of
    # files in the S3 bucket:
    #
    #   https://s3-us-west-2.amazonaws.com/confluent.cloud?prefix=confluent-cli/archives/1.25.0/&delimiter=/%27
    platforms = lib.platforms.unix;
  };
})
