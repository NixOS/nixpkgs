{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kcl-cli";
  version = "0.8.8";
  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Bk/sCNMDupdY/YyKT+VoPIzEfjFDa5z9pevcCPnTX8U=";
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
