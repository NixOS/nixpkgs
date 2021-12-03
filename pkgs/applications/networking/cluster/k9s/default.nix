{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k9s";
  version = "0.25.7";

  src = fetchFromGitHub {
    owner  = "derailed";
    repo   = "k9s";
    rev    = "v${version}";
    sha256 = "sha256-CFXPo8dpefrrBxCGpcGtZfLdfMYCBL/eQhHqZggK/yA=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/derailed/k9s/cmd.version=${version}"
    "-X github.com/derailed/k9s/cmd.commit=${src.rev}"
  ];

  vendorSha256 = "sha256-v4cd+f2GSE2ad0wWrW9x6/U6RREhFV83wVNFUMfWaA4=";

  preCheck = "export HOME=$(mktemp -d)";

  doCheck = true;

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    license = licenses.asl20;
    maintainers = with maintainers; [ Gonzih markus1189 bryanasdev000 ];
  };
}
