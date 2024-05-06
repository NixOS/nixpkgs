{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kcl-cli";
  version = "0.8.7";
  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-OKRMgxynKmHnO+5tcKlispFkpQehHINzB6qphH+lwHQ=";
  };
  vendorHash = "sha256-dF0n1/SmQVd2BUVOPmvZWWUJYTn2mMnbgZC92luSY2s=";
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
