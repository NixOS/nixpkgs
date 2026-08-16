{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rabbitmq";
  version = "2.22.4";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "cluster-operator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q7tRybGbuNV0Vs5kIV409zP0EtePtTvdIBF62BfbXv4=";
  };

  modRoot = "kubectl-rabbitmq";

  vendorHash = "sha256-TYSZTXexoOD+G/2rJv+z+BfvusQGmKdg2HHONbRAZsk=";

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
