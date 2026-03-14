{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rabbitmq";
  version = "2.19.2";

  src = fetchFromGitHub {
    owner = "rabbitmq";
    repo = "cluster-operator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FGer31UxUcMcbgcMYag4FzHykEA1EsSaER+C169ZC18=";
  };

  modRoot = "bin/kubectl-rabbitmq-plugin";

  vendorHash = "sha256-Ccxu5NcP2W5Ur6FxPnOft9XibdarYinWaxMtXyqNydk=";

  postPatch = ''
    substituteInPlace bin/kubectl-rabbitmq-plugin/go.mod go.mod \
      --replace-fail 'go 1.25.8' 'go 1.25.7'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.pluginVersion=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/kubectl-rabbitmq-plugin $out/bin/kubectl-rabbitmq
  '';

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
