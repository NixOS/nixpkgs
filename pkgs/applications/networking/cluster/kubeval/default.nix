{ lib, fetchFromGitHub, buildGoModule, makeWrapper }:

buildGoModule rec {
  pname = "kubeval";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "kubeval";
    rev = version;
    sha256 = "sha256-c5UESyWK1rfnD0etOuIroBUSqZQuu57jio7/ArItMP0=";
  };

  vendorSha256 = "sha256-SqYNAUYPUJYmHj4cFEYqQ8hEkYWmmpav9AGOSFDc/M4=";

  doCheck = false;

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = "https://github.com/instrumenta/kubeval";
    license = licenses.asl20;
    maintainers = with maintainers; [ johanot nicknovitski ];
  };
}
