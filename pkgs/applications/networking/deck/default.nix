{ buildGoModule, lib, installShellFiles, fetchFromGitHub }:

buildGoModule rec {
  pname = "deck";
  version = "1.32.1";

  src = fetchFromGitHub {
    owner = "Kong";
    repo = "deck";
    rev = "v${version}";
    hash = "sha256-7lE/Wnrlv3L6V1ex+357q6XXpdx0810m1rKkqITowXY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s -w -X github.com/kong/deck/cmd.VERSION=${version}"
    "-X github.com/kong/deck/cmd.COMMIT=${src.rev}"
  ];

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-D260T3E0aufOAqlN918SChv3aNDCFHfe2e0It1pcPiU=";

  postInstall = ''
    installShellCompletion --cmd deck \
      --bash <($out/bin/deck completion bash) \
      --fish <($out/bin/deck completion fish) \
      --zsh <($out/bin/deck completion zsh)
  '';

  meta = with lib; {
    description = "A configuration management and drift detection tool for Kong";
    homepage = "https://github.com/Kong/deck";
    license = licenses.asl20;
    maintainers = with maintainers; [ liyangau ];
  };
}
