{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aiac";
  version = "5.0.0";
  excludedPackages = [".ci"];

  src = fetchFromGitHub {
    owner = "gofireflyio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4XjtzfICFCy2mA0FK0yV/hI5PPVpgXt5LlJTAxQAVq8=";
  };

  vendorHash = "sha256-uXYin6JITpy3bc7FI/3aJqvCD9cGwGL1qjB8hBUWLQE=";
  ldflags = [ "-s" "-w" "-X github.com/gofireflyio/aiac/v4/libaiac.Version=v${version}" ];

  meta = with lib; {
    description = ''Artificial Intelligence Infrastructure-as-Code Generator.'';
    mainProgram = "aiac";
    homepage = "https://github.com/gofireflyio/aiac/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
