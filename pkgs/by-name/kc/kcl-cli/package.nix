{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kcl-cli";
  version = "0.8.5";
  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-ZjEMgQukhBGY3LWqsGmLj3lKfLtNNaQugQs0cSLMb80=";
  };
  vendorHash = "sha256-jmqKMB85HxAlwH7FVjHrLCZQYuAJrguRfzIz1yMypjw=";
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
