{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "timoni";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "stefanprodan";
    repo = "timoni";
    rev = "v${version}";
    hash = "sha256-1l+PEG3ptlWmM48v9K7Rm090WF8cv+e2ezYFN2JRK/o=";
  };

  vendorHash = "sha256-Mgo6Q3P8Piv5uLgyXDGpRI4CgbZn1DUcM7XhVZxl8EE=";

  subPackages = [ "cmd/timoni" ];
  nativeBuildInputs = [ installShellFiles ];

  # Some tests require running Kubernetes instance
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.VERSION=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd timoni \
    --bash <($out/bin/timoni completion bash) \
    --fish <($out/bin/timoni completion fish) \
    --zsh <($out/bin/timoni completion zsh)
  '';

  meta = with lib; {
    homepage = "https://timoni.sh";
    changelog = "https://github.com/stefanprodan/timoni/releases/tag/${src.rev}";
    description = "A package manager for Kubernetes, powered by CUE and inspired by Helm";
    license = licenses.asl20;
    maintainers = with maintainers; [ votava ];
  };
}
