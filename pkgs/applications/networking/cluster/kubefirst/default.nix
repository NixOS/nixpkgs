{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "kubefirst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JGseXRUehRuH1kuTfmkAJcfRN3vM0zN7K8pnOfJ0LAs=";
  };

  vendorHash = "sha256-Sc6HXJXkZ9vW6sxEKCTo6LDHeOGLTz0oN9JH11iUA/k=";

  ldflags = [ "-s" "-w" "-X github.com/kubefirst/runtime/configs.K1Version=v${version}"];

  doCheck = false;

  meta = with lib; {
    description = "The Kubefirst CLI creates instant GitOps platforms that integrate some of the best tools in cloud native from scratch.";
    homepage = "https://github.com/kubefirst/kubefirst/";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
