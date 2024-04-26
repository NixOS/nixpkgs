{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kcl-cli";
  version = "0.8.6";
  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-A98Y5ktXFwn1XrFTwL8l04VW5zPNcMLtZCUf+niXx6c=";
  };
  vendorHash = "sha256-zFTcwyK5HT1cwfHJB3n5Eh2JE3xuXqAluU3McA+FurQ=";
  ldflags = [
    "-X=kcl-lang.io/cli/pkg/version.version=${version}"
  ];
  subPackages = [ "cmd/kcl" ];
  meta = with lib; {
    description = "A command line interface for KCL programming language";
    homepage = "https://github.com/kcl-lang/cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ peefy ];
    mainProgram = "kcl";
  };
}
