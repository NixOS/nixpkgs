{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "acorn";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "acorn-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WrwpfRzGm+DPxJ1A6BEIf6sfuIHWGvSOm3Gm0GhEfZc=";
  };

  vendorHash = "sha256-ebUYPvJInR6Vr8unlMVKEbJX4wzb6vcnNiElFY3doaQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/acorn-io/acorn/pkg/version.Tag=v${version}"
  ];

  # integration tests require network and kubernetes master
  doCheck = false;

  meta = with lib; {
    homepage = "https://docs.acorn.io";
    changelog = "https://github.com/acorn-io/${pname}/releases/tag/v${version}";
    description = "A simple application deployment framework for Kubernetes";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
