{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rabbitmq";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "cluster-operator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/ndLT30ARVaRbK6/+6Z+s5+VQJmAFLWoI9TIHV7BOzI=";
  };

  modRoot = "kubectl-rabbitmq";

  vendorHash = "sha256-Jud0VpVcBPBtc3hgb997SzefZx7kM9hbPgdOqBRDezY=";

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
