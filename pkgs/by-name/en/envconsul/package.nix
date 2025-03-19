{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  envconsul,
}:

buildGoModule rec {
  pname = "envconsul";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "envconsul";
    rev = "v${version}";
    hash = "sha256-hPq+r4DOMu2elOpaT0xDQoelUb1D/zYM/a6fZZdu/AY=";
  };

  vendorHash = "sha256-0hrZsh08oWqhVqvM6SwUskYToH6Z4YWmV/i0V2MkFMw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/envconsul/version.Name=envconsul"
  ];

  passthru.tests.version = testers.testVersion {
    package = envconsul;
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
    mainProgram = "envconsul";
  };
}
