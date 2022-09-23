{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kompose, git }:

buildGoModule rec {
  pname = "kompose";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kompose";
    rev = "v${version}";
    sha256 = "sha256-NfzqGG5ZwPpmjhvcvXN1AA+kfZG/oujbAEtXkm1mzeU=";
  };

  vendorSha256 = "sha256-OR5U2PnebO0a+lwU09Dveh0Yxk91cmSRorTxQIO5lHc=";

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
    platforms = platforms.unix;
  };
}
