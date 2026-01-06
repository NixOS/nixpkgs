{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  pscale,
  testers,
}:

buildGoModule rec {
  pname = "pscale";
  version = "0.268.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-z6hvjwrIscZHC/3pZkknyAMWpXEAItEhioRK37o82aw=";
  };

  vendorHash = "sha256-0Db91ESDf+5j4+da4F44uxycGDBV4A5Wkwz8Uvjo9ec=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.commit=v${version}"
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
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    homepage = "https://www.planetscale.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
}
