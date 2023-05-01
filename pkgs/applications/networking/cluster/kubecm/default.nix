{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubecm";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-0oQOuBYCDNnOODM2ZSqTgOI+jHWuHTtsk2NfGIPMy5A=";
  };

  vendorHash = "sha256-fVPiEDB6WFu2x5EY7NjmJEEq297QxP10593cXxxv8iI=";
  ldflags = [ "-s" "-w" "-X github.com/sunny0826/kubecm/version.Version=${version}"];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
