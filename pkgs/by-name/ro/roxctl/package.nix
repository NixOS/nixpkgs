{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  roxctl,
}:

buildGoModule (finalAttrs: {
  pname = "roxctl";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "stackrox";
    rev = finalAttrs.version;
    sha256 = "sha256-rE0VSb0Lup1/rNtX9IGeMMUmIusq/09CtbYXRljZPHA=";
  };

  vendorHash = "sha256-FrWS34jFV8NFvcWga6o8wA3US+e6TQKxSio5pp7H21E=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "roxctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stackrox/rox/pkg/version/internal.MainVersion=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd roxctl \
      --bash <($out/bin/roxctl completion bash) \
      --fish <($out/bin/roxctl completion fish) \
      --zsh <($out/bin/roxctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = roxctl;
    command = "roxctl version";
  };

  meta = {
    description = "Command-line client of the StackRox Kubernetes Security Platform";
    mainProgram = "roxctl";
    license = lib.licenses.asl20;
    homepage = "https://www.stackrox.io";
    maintainers = with lib.maintainers; [ stehessel ];
  };
})
