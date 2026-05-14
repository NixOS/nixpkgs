{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  stdenv,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "kyverno-chainsaw";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "kyverno";
    repo = "chainsaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wHwjcpcum3ByBGYUxJ38Qi0RliQUmAIBYmE7t3gEonI=";
  };

  patches = [ ./go-1.26-testdeps-modulepath.patch ];

  vendorHash = "sha256-lG+odKD1TGQ7GTh/y9ogREtY59T8fvN/6FyKsdgsU0M=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kyverno/chainsaw/pkg/version.BuildVersion=v${finalAttrs.version}"
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
    package = finalAttrs.finalPackage;
    command = "chainsaw version";
    version = "v${finalAttrs.version}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/kyverno/chainsaw/releases/tag/v${finalAttrs.version}";
    description = "Declarative approach to test Kubernetes operators and controllers";
    homepage = "https://kyverno.github.io/chainsaw/";
    license = lib.licenses.asl20;
    longDescription = ''
      Chainsaw is meant to test Kubernetes operators work as expected by running a sequence of test steps for:
      * Creating resources
      * Asserting operators react (or not) the way they should
    '';
    mainProgram = "chainsaw";
    maintainers = [ ];
  };
})
