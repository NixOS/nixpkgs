{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "confluent-cli";
  version = "4.41.0";

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
        x86_64-linux = "sha256-JY0emiNT2l0wIa8jgaiVu2sMfIwY+II6h0uDLzeGhqc=";
        aarch64-linux = "sha256-jWLIOolU+b1sKz1X8QdsFAwF0xsFj8VwIRZi3Y8C9z0=";
        x86_64-darwin = "sha256-pPnAbHdhFgrux3XG+GXdT2NCQDSpZqopDoZTlyuQOMk=";
        aarch64-darwin = "sha256-pS+coSuTrzWuVDu+Yp/m/FnP1kcQKXvROrcWuATM7mU=";
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
