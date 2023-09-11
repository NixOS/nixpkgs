{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pluto";
  version = "5.18.4";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-/8ZJXy5FErLnnXpED0UL+xqOo4QZtmR1hpcSpVsE8mw=";
  };

  vendorHash = "sha256-ysMRE/OwMf4rBnlkpkW9K8ZHEEbHpQ02RXNwLLSr0nY=";

  ldflags = [
    "-w" "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterromfeldhk kashw2 ];
  };
}
