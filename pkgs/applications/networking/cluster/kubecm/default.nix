{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecm";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-8Y8JChZxjbN/nOw2tzDfJvYSMAtAadf6QMsDFK4IIOg=";
  };

  vendorHash = "sha256-HjMgXEDX9pDpK+1Hm0xI0wYRfpj7K6xkZJXCUBqbE3Y=";
  ldflags = [ "-s" "-w" "-X github.com/sunny0826/kubecm/version.Version=${version}"];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
