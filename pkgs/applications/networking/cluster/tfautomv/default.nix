{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tfautomv";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "busser";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-irB0Kfd8eqIKq0ooJRxB0X4t2/1aFCNYRwaG6lAw3ic=";
  };

  vendorHash = "sha256-Wc5hpiHL5I01IodcHX0IzeKfthkFS7SuUxmaxOU6WkA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/busser/tfautomv";
    description = "When refactoring a Terraform codebase, you often need to write moved blocks. This can be tedious. Let tfautomv do it for you";
    mainProgram = "tfautomv";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
