{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "ctlptl";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = "ctlptl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vbg3gaVCFkQ6jKguNq6ClstEKpTrk9ryUG572emEY4U=";
  };

  vendorHash = "sha256-b9lzCNjO0rrK/kJlw5dssuQD/cyf/Wu/LJ2YNQ645LE=";

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
