{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "eksctl";
  version = "0.225.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "eksctl";
    rev = finalAttrs.version;
    hash = "sha256-aGIn6/CHC/0RGgVQJbye09V5cT2gXYhvihUv4J/1l6g=";
  };

  vendorHash = "sha256-6f/w++wQdedkzvwkktDvpmpkR5eCJvG2twCSKxY49ZQ=";

  doCheck = false;

  subPackages = [ "cmd/eksctl" ];

  tags = [
    "netgo"
    "release"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/weaveworks/eksctl/pkg/version.gitCommit=${finalAttrs.src.rev}"
    "-X github.com/weaveworks/eksctl/pkg/version.buildDate=19700101-00:00:00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd eksctl \
      --bash <($out/bin/eksctl completion bash) \
      --fish <($out/bin/eksctl completion fish) \
      --zsh  <($out/bin/eksctl completion zsh)
  '';

  meta = {
    description = "CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    changelog = "https://github.com/eksctl-io/eksctl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      xrelkd
      Chili-Man
      ryan4yin
    ];
    mainProgram = "eksctl";
  };
})
