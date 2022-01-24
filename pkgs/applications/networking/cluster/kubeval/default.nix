{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
}:

buildGoModule rec {
  pname = "kubeval";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "kubeval";
    rev = "v${version}";
    sha256 = "sha256-pwJOV7V78H2XaMiiJvKMcx0dEwNDrhgFHmCRLAwMirg=";
  };

  vendorSha256 = "sha256-OAFxEb7IWhyRBEi8vgmekDSL/YpmD4EmUfildRaPR24=";

  doCheck = false;

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = "https://github.com/instrumenta/kubeval";
    license = licenses.asl20;
    maintainers = with maintainers; [ johanot nicknovitski ];
  };
}
