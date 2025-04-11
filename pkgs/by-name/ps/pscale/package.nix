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
  version = "0.236.0";

  src = fetchFromGitHub {
    owner = "planetscale";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-sL/TBcUtHYqZuUp5JlcKshwlyVSf0t0XukMmRkWRyvk=";
  };

  vendorHash = "sha256-Uw4A6RBq0OiBHWRfmj9wKI2FenDN6C8CWEsKicGS/1Q=";

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

  meta = with lib; {
    description = "CLI for PlanetScale Database";
    mainProgram = "pscale";
    changelog = "https://github.com/planetscale/cli/releases/tag/v${version}";
    homepage = "https://www.planetscale.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      pimeys
      kashw2
    ];
  };
}
