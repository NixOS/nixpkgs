{ buildGoModule, lib, installShellFiles, fetchFromGitHub }:

buildGoModule rec {
  pname = "deck";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "Kong";
    repo = "deck";
    rev = "v${version}";
    hash = "sha256-UQgNLlV4FoKd23zkReTftDnHBtjtKjoXuqJPGTNX+CI=";
  };

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s -w -X github.com/kong/deck/cmd.VERSION=${version}"
    "-X github.com/kong/deck/cmd.COMMIT=${src.rev}"
  ];

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-qLcOL7XuXNR/9Q/D5I7KcMNdveACommFndHjqpbPfbE=";

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
