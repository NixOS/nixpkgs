{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "deepsource";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "DeepSourceCorp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-6uNb4cQVerrlW/eUkjmlO1i1YKYX3qaVdo0i5cczt+I=";
  };

  doCheck = false;
  doInstallCheck = true;

  vendorHash = "sha256-SsMq4ngq3sSOL28ysHTxTF4CT9sIcCIW7yIhBxIPrNs=";

  ldflags = [ "-s" "-w" "-X=main.version=${version}" ];

  meta = with lib; {
    description = "Command line interface to DeepSource";
    mainProgram = "deepsource";
    homepage = "https://github.com/DeepSourceCorp/cli";
    license = licenses.bsd3;
  };
}
