{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kompose, git }:

buildGoModule rec {
  pname = "kompose";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kompose";
    rev = "v${version}";
    hash = "sha256-W9KAjyMp8fbnZunH5hwj0uctNYxEN/vbEDGaFJpv5hM=";
  };

  vendorHash = "sha256-nY0d3r3faowHa7ylqDkUrX6MrGW3g1jYjm1MLFW/jK8=";

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
    mainProgram = "kompose";
    homepage = "https://kompose.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ thpham vdemeester ];
  };
}
