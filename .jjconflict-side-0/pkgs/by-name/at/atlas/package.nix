{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "atlas";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1uPOS5r13nGNAPxCCphrmWyvxg+OoopMP0U/VhR+gDQ=";
  };

  modRoot = "cmd/atlas";

  proxyVendor = true;
  vendorHash = "sha256-K94zOisolCplE/cFrWmv4/MWl5DD27lRekPTl+o4Jwk=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  postInstall = ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "atlas version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Modern tool for managing database schemas";
    homepage = "https://atlasgo.io/";
    changelog = "https://github.com/ariga/atlas/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "atlas";
  };
})
