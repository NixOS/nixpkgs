{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "ctlptl";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = "ctlptl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4c/sEWzKhs0PjHmZzVs8jXdWe2GWHYNFGsA9cQF5tOI=";
  };

  vendorHash = "sha256-nlLx2+NdhqkhpwM7E5PwKcFW+MsJLeSoXWRdtQjFV4Q=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/ctlptl" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ctlptl \
      --bash <($out/bin/ctlptl completion bash) \
      --fish <($out/bin/ctlptl completion fish) \
      --zsh <($out/bin/ctlptl completion zsh)
  '';

  meta = {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ svrana ];
  };
})
