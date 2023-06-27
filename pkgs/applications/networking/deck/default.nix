{ buildGoModule, lib, installShellFiles, fetchFromGitHub }:
let
  short_hash = "7447a09";
in buildGoModule rec {
  pname = "deck";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "Kong";
    repo = "deck";
    rev = "v${version}";
    hash = "sha256-BCx4bw+FrnH291sp52Dz+dc6cYtoLAt8fmdF6YbmgOE=";
  };

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s -w -X github.com/kong/deck/cmd.VERSION=${version}"
    "-X github.com/kong/deck/cmd.COMMIT=${short_hash}"
  ];

  vendorSha256 = "sha256-rir8z1IwQenTvihHWaA7dx6Nn45M82ulCNRJuQlUhEM=";

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
