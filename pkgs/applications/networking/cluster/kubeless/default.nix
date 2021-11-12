{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "kubeless";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "kubeless";
    repo = "kubeless";
    rev = "v${version}";
    sha256 = "0x2hydywnnlh6arzz71p7gg9yzq5z2y2lppn1jszvkbgh11kkqfr";
  };

  goPackagePath = "github.com/kubeless/kubeless";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/kubeless" ];

  ldflags = [
    "-s" "-w" "-X github.com/kubeless/kubeless/pkg/version.Version=${version}"
  ];

  postInstall = ''
    for shell in bash; do
      $out/bin/kubeless completion $shell > kubeless.$shell
      installShellCompletion kubeless.$shell
    done
  '';

  meta = with lib; {
    homepage = "https://kubeless.io";
    description = "The Kubernetes Native Serverless Framework";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    platforms = platforms.unix;
  };
}
