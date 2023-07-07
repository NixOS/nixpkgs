{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubefirst";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "kubefirst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6vtuMUTlMOgdUqoCidSKg5liOQWfM+cppUXwX4YYGGA=";
  };

  vendorHash = "sha256-4q/r6LR97uX6QZQN6Y7NCf1ilcGjorIUGIvhTVfkeZg=";

  ldflags = [ "-s" "-w" "-X github.com/kubefirst/runtime/configs.K1Version=v${version}"];

  doCheck = false;

  meta = with lib; {
    description = "The Kubefirst CLI creates instant GitOps platforms that integrate some of the best tools in cloud native from scratch.";
    homepage = "https://github.com/kubefirst/kubefirst/";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
