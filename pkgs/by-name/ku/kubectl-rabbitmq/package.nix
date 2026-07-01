{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rabbitmq";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "cluster-operator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6kh4R84Nq82M66Y0vl1NLYUxWh52oYpCydK7vOmkMcU=";
  };

  modRoot = "kubectl-rabbitmq";

  vendorHash = "sha256-/50MnUk1wxpUed8jZ8OC6rgu4Qj6CnUZdbYsgyjsxIo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.pluginVersion=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "RabbitMQ Cluster Operator Plugin for kubectl";
    homepage = "https://github.com/rabbitmq/cluster-operator";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ surfaceflinger ];
    mainProgram = "kubectl-rabbitmq";
    platforms = lib.platforms.all;
  };
})
