{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "confluent-cli";
  version = "4.28.0";

  # To get the latest version:
  # curl -L https://cnfl.io/cli | sh -s -- -l | grep -v latest | sort -V | tail -n1
  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      system = selectSystem {
        x86_64-linux = "linux_amd64";
        aarch64-linux = "linux_arm64";
        x86_64-darwin = "darwin_amd64";
        aarch64-darwin = "darwin_arm64";
      };
    in
    fetchurl {
      url = "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/${finalAttrs.version}/confluent_${finalAttrs.version}_${system}.tar.gz";
      hash = selectSystem {
        x86_64-linux = "sha256-UZenEPriotCx+HQJocJFR3rm6tQWvWldiUwzSS9/7G8=";
        aarch64-linux = "sha256-/hTU4ev7j5paGRMpFXPSQ3se8VGJ0XsSWF9EO4V3XF4=";
        x86_64-darwin = "sha256-4lRhQJCKyKNeLqCPro0bmSUE9c0iCMBbR1PR7SPhmiE=";
        aarch64-darwin = "sha256-SCY4QVFKAfqHNnz2Pj7lE4kdNH80yHX6XR6lPV+Kwqw=";
      };
    };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/doc/confluent-cli}
    cp confluent $out/bin/
    cp LICENSE $out/share/doc/confluent-cli/
    cp -r legal $out/share/doc/confluent-cli/

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Confluent CLI";
    homepage = "https://docs.confluent.io/confluent-cli/current/overview.html";
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
