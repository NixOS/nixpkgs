{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kcl-cli";
  version = "0.8.9";
  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-slU3n7YCV5VfvXArzlcITb9epdu/gyXlAWq9KLjGdJA=";
  };
  vendorHash = "sha256-Xv8Tfq9Kb1xGFCWZQwBFDX9xZW9j99td/DUb7jBtkpE=";
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
