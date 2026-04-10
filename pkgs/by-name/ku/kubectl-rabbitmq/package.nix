{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rabbitmq";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "cluster-operator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-anJZy0XUEJ0j912g7+ltq2bMVE/KPpyBWuh7AqGgx30=";
  };

  modRoot = "kubectl-rabbitmq";

  vendorHash = "sha256-UnZ47TUarqZNYrvpfNJy5tm9Yq5/eFrkMSLRqjqM9PU=";

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
