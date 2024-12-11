{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  kompose,
  git,
}:

buildGoModule rec {
  pname = "kompose";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kompose";
    rev = "v${version}";
    hash = "sha256-lBNf/pNJulex3WNRx8ZQcGag2nUPqjPKU9X/xDNxQjc=";
  };

  vendorHash = "sha256-SakezUp2Gj1PxY1Gwf8tH2yShtB/MPIqGjM/scrGG4I=";

  nativeBuildInputs = [
    installShellFiles
    git
  ];

  ldflags = [
    "-s"
    "-w"
  ];

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
    description = "Tool to help users who are familiar with docker-compose move to Kubernetes";
    mainProgram = "kompose";
    homepage = "https://kompose.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      thpham
      vdemeester
    ];
  };
}
