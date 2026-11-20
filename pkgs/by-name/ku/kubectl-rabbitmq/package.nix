{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rabbitmq";
  version = "2.22.5";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "cluster-operator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BnxOUFXlHz8+uXa7OPWFxNs45lN0QTelN0CIvGudekk=";
  };

  modRoot = "kubectl-rabbitmq";

  vendorHash = "sha256-DcD++p/ivqnkC4I/S4wSpjPmUhTOjjN+jk3glvIEi+0=";

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
