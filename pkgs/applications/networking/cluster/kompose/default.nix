{ lib, buildGoModule, fetchFromGitHub, fetchpatch, installShellFiles, testers, kompose, git }:

buildGoModule rec {
  pname = "kompose";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kompose";
    rev = "v${version}";
    sha256 = "sha256-NfzqGG5ZwPpmjhvcvXN1AA+kfZG/oujbAEtXkm1mzeU=";
  };

  vendorHash = "sha256-/i4R50heqf0v2F2GTZCKGq10+xKKr+zPkqWKa+afue8=";

  patches = [
    (fetchpatch {
      url = "https://github.com/kubernetes/kompose/commit/0964a7ccd16504b6e5ef49a07978c87cca803d46.patch";
      hash = "sha256-NMHLxx7Ae6Z+pacj538ivxIby7rNz3IbfDPbeLA0sMc=";
    })
  ];

  nativeBuildInputs = [ installShellFiles git ];

  ldflags = [ "-s" "-w" ];

  checkFlags = [ "-short" ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/kompose completion $shell > kompose.$shell
      installShellCompletion kompose.$shell
    done
  '';

  passthru.tests.version = testers.testVersion {
    package = kompose;
    command = "kompose version";
  };

  meta = with lib; {
    description = "A tool to help users who are familiar with docker-compose move to Kubernetes";
    homepage = "https://kompose.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ thpham vdemeester ];
  };
}
