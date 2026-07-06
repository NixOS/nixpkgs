{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  pscale,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "pscale";
  version = "0.291.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-dvWUriwAMgJMSkQPVNu5Ff4KFbp4KPE8lbY2OlttbzA=";
  };

  vendorHash = "sha256-n09VZjMHFnP/myZ0gqWdeD8QOQf3PpTJ9PUfb4x2zHo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.commit=v${finalAttrs.version}"
    "-X main.date=unknown"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pscale \
      --bash <($out/bin/pscale completion bash) \
      --fish <($out/bin/pscale completion fish) \
      --zsh <($out/bin/pscale completion zsh)
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = pscale;
  };

  meta = {
    description = "CLI for PlanetScale Database";
    mainProgram = "pscale";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${finalAttrs.version}";
    homepage = "https://www.planetscale.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
})
