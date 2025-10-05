{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kyverno-chainsaw,
  lib,
  nix-update-script,
  stdenv,
  testers,
}:

buildGoModule rec {
  pname = "kyverno-chainsaw";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "kyverno";
    repo = "chainsaw";
    rev = "v${version}";
    hash = "sha256-DbwqcHBmKAzq3xzUVGOdXjF8uaUWkEKRlz9m7tfyIdY=";
  };

  vendorHash = "sha256-e4hSfmnROnfLRNvmfN0VFoIR0zVaqBhd0/c4lIyScvY=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kyverno/chainsaw/pkg/version.BuildVersion=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false; # requires running kubernetes

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd kyverno-chainsaw \
        --$shell <($out/bin/chainsaw completion $shell)
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = kyverno-chainsaw;
    command = "chainsaw version";
    version = "v${version}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/kyverno/chainsaw/releases/tag/v${version}";
    description = "Declarative approach to test Kubernetes operators and controllers";
    homepage = "https://kyverno.github.io/chainsaw/";
    license = lib.licenses.asl20;
    longDescription = ''
      Chainsaw is meant to test Kubernetes operators work as expected by running a sequence of test steps for:
      * Creating resources
      * Asserting operators react (or not) the way they should
    '';
    mainProgram = "chainsaw";
    maintainers = with lib.maintainers; [ ];
  };
}
