{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kubent,
}:

buildGoModule rec {
  pname = "kubent";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = version;
    sha256 = "sha256-/gCbj0RDwV5E8kNkEu+37ilzw/A0BAXiYfHGPdkCsRs=";
  };

  vendorHash = "sha256-6hp7mzE45Tlmt4ybhpdJLYCv+WqQ9ak2S47kJTwyGVI=";

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

  meta = with lib; {
    homepage = "https://github.com/doitintl/kube-no-trouble";
    description = "Easily check your cluster for use of deprecated APIs";
    mainProgram = "kubent";
    license = licenses.mit;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
