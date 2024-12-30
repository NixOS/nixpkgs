{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  cyphernetes,
}:

buildGoModule rec {
  pname = "cyphernetes";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "AvitalTamir";
    repo = "cyphernetes";
    rev = "v${version}";
    hash = "sha256-rxZWI+2eWMNTjphxS+lsxAoZUXD8wWF1pfe6hLBxtuM=";
  };

  ldflags = [
    "-X main.Version=${version}"
  ];

  vendorHash = "sha256-DRzYgpHShZn+17R1Jj/arwAP5lyTpWelmwloUxT3n5Y=";
  doCheck = false; # kubeconfig doesn't have a current context, ignore for now

  # we build only the cli in this first iteration. webserver and other components might follow
  subPackages = [
    "cmd/cyphernetes"
  ];

  meta = with lib; {
    description = "A Kubernetes Query Language ";
    homepage = "https://github.com/AvitalTamir/cyphernetes";
    changelog = "https://github.com/AvitalTamir/cyphernetes/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "cyphernetes";
    maintainers = with maintainers; [ stefankeidel ];
  };
}
