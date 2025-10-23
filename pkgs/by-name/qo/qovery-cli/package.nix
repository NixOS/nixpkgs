{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  qovery-cli,
  testers,
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = "qovery-cli";
    tag = "v${version}";
    hash = "sha256-NxrhZmRbkQNj2K4b6Em4cAdssJRdwEKbdGy8EThN4JY=";
  };

  vendorHash = "sha256-GKW89qzyuvwCUvN0i+LgU36Vtr5XuvgXIxwnMlGSTFg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = qovery-cli;
    command = "HOME=$(mktemp -d); ${pname} version";
  };

  meta = {
    description = "Qovery Command Line Interface";
    homepage = "https://github.com/Qovery/qovery-cli";
    changelog = "https://github.com/Qovery/qovery-cli/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "qovery-cli";
  };
}
