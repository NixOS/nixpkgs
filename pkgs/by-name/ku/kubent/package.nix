{
  buildGoModule,
  fetchFromGitHub,
  kubent,
  lib,
  testers,
}:

buildGoModule rec {
  pname = "kubent";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = version;
    hash = "sha256-7bn7DxbZ/Nqob7ZEWRy1UVg97FiJN5JWEgpH1CDz6jQ=";
  };

  vendorHash = "sha256-+V+/TK60V8NYUDfF5/EgSZg4CLBn6Mt57diiyXm179k=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=v${version}"
  ];

  subPackages = [ "cmd/kubent" ];

  passthru.tests.version = testers.testVersion {
    package = kubent;
    command = "kubent --version";
    version = "v${version}";
  };

  meta = {
    description = "Easily check your cluster for use of deprecated APIs";
    changelog = "https://github.com/doitintl/kube-no-trouble/releases/tag/${version}";
    homepage = "https://github.com/doitintl/kube-no-trouble";
    license = lib.licenses.mit;
    mainProgram = "kubent";
    maintainers = with lib.maintainers; [ peterromfeldhk ];
  };
}
