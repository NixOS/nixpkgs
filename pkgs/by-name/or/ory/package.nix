{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ory";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-5N69/Gv4eYLbZNN+sEx+RcFyhGCT0hUxDCje1qrbWiY=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  CGO_ENABLED = 1;

  tags = [
    "sqlite"
  ];

  vendorHash = "sha256-J9jyeLIT+1pFnHOUHrzmblVCJikvY05Sw9zMz5qaDOk=";

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
    homepage = "https://www.ory.sh/";
    license = licenses.asl20;
    maintainers = with maintainers; [ luleyleo ];
  };
}
