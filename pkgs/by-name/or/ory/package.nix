{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ory";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-q7+Fpttgx62GbKxCCiEDlX//e/pNO24e7KhhBeGRDH0=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  CGO_ENABLED = 1;

  tags = [
    "sqlite"
  ];

  vendorHash = "sha256-B0y1JVjJmC5eitn7yIcDpl+9+xaBDJBMdvm+7N/ZxTk=";

  postInstall = ''
    mv $out/bin/cli $out/bin/ory
    installShellCompletion --cmd ory \
      --bash <($out/bin/ory completion bash) \
      --fish <($out/bin/ory completion fish) \
      --zsh <($out/bin/ory completion zsh)
  '';

  meta = with lib; {
    mainProgram = "ory";
    description = "The Ory CLI";
    homepage = "https://www.ory.sh/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ luleyleo nicolas-goudry ];
  };
}
