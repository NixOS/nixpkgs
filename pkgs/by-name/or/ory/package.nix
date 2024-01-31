{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ory";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-o5ii8+tQzVcoIgTHQ9nnGJf2VKhWhL+osbAKPB7esDA=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  CGO_ENABLED = 1;

  tags = [
    "sqlite"
  ];

  vendorHash = "sha256-iUPZbeCZ08iDf8+u2CoVH1yN2JyBqQjeS3dAKUMyX9Y=";

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
