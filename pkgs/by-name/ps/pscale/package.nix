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
  version = "0.277.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4mNhlwxk7+vliAao/KA6UBosFKkOg6p91EYC+iDfDkY=";
  };

  vendorHash = "sha256-vjW8wJoJBtFcKo5TpFRHKwBDh+5Z60EM+3KqyYbcwAc=";

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
