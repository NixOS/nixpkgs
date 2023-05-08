{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aiac";
  version = "2.4.0";
  excludedPackages = [".ci"];

  src = fetchFromGitHub {
    owner = "gofireflyio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-C9eQdN8S8Qe0x+Uly69nbYNXDKpi1uZ6qNBetn2P4Gk=";
  };

  vendorHash = "sha256-Uqr9wH7hCLdZEu6DXddgB7NuLtqcjUbOPJ2YX+9ehKM=";
  ldflags = [ "-s" "-w" "-X github.com/gofireflyio/aiac/v3/libaiac.Version=v${version}" ];

  meta = with lib; {
    description = ''Artificial Intelligence Infrastructure-as-Code Generator.'';
    homepage = "https://github.com/gofireflyio/aiac/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
