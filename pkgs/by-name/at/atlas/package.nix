{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  atlas,
}:

buildGoModule rec {
  pname = "atlas";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${version}";
    hash = "sha256-OPGPYCp878nYYujR1jiMpOg1cdLSwa3OZEIxL6JltD4=";
  };

  modRoot = "cmd/atlas";

  proxyVendor = true;
  vendorHash = "sha256-SFG//hc5vLQXC3SeEn4YRcc82PItYZy+TNqzq19sRnI=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v${version}"
  ];

  subPackages = [ "." ];

  postInstall = ''
    installShellCompletion --cmd atlas \
      --bash <($out/bin/atlas completion bash) \
      --fish <($out/bin/atlas completion fish) \
      --zsh <($out/bin/atlas completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = atlas;
    command = "atlas version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Modern tool for managing database schemas";
    homepage = "https://atlasgo.io/";
    changelog = "https://github.com/ariga/atlas/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "atlas";
  };
}
