{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecm";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-BywtQ6YVGPz5A0GE2q0zRoBZNU6HZgVbr6H0OMR05wM=";
  };

  vendorHash = "sha256-WZxjv4v2nfJjbzFfaDh2kE7ZBREB+Q8BmHhUrAiDd7g=";
  ldflags = [ "-s" "-w" "-X github.com/sunny0826/kubecm/version.Version=${version}"];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
