{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  writeShellApplication,
  coreutils,
}:

let
  kubectl-rabbitmq = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "kubectl-rabbitmq";
    version = "2.18.0";

    src = fetchFromGitHub {
      owner = "rabbitmq";
      repo = "cluster-operator";
      tag = "v${finalAttrs.version}";
      hash = "sha256-797/pTicHTW7iFn8AjSuwVl9MqvEwRZfSQiLLi4w7MA=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 bin/kubectl-rabbitmq -t $out/bin

      runHook postInstall
    '';

  });
in
writeShellApplication {
  name = "kubectl-rabbitmq";
  runtimeInputs = [
    coreutils
    kubectl-rabbitmq
  ];
  text = ''
    kubectl-rabbitmq "$@"
  '';
  meta = {
    description = "RabbitMQ Cluster Operator Plugin for kubectl";
    homepage = "https://github.com/rabbitmq/cluster-operator";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ surfaceflinger ];
    mainProgram = "kubectl-rabbitmq";
    platforms = lib.platforms.all;
  };
}
