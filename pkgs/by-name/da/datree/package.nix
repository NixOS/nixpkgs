{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  datree,
}:

buildGoModule rec {
  pname = "datree";
  version = "1.9.19";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    tag = version;
    hash = "sha256-W1eX7eUMdPGbHA/f08xkG2EUeZmaunEAQn7/LRBe2nk=";
  };

  vendorHash = "sha256-+PQhuIO4KjXtW/ZcS0OamuOHzK7ZL+nwOBxeCRoXuKE=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  tags = [ "main" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --cmd datree \
      --bash <($out/bin/datree completion bash) \
      --fish <($out/bin/datree completion fish) \
      --zsh <($out/bin/datree completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = datree;
    command = "datree version";
  };

  meta = {
    description = "CLI tool to ensure K8s manifests and Helm charts follow best practices";
    mainProgram = "datree";
    longDescription = ''
      Datree provides an E2E policy enforcement solution to run automatic checks
      for rule violations. Datree can be used on the command line, admission
      webhook, or even as a kubectl plugin to run policies against Kubernetes
      objects.
    '';
    homepage = "https://datree.io/";
    changelog = "https://github.com/datreeio/datree/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      azahi
      jceb
    ];
  };
}
