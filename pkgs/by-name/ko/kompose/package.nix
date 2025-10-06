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
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kompose";
    rev = "v${version}";
    hash = "sha256-wS9YoYEsCALIJMxoVTS6EH6NiBfF+qkFIv7JALnVPgs=";
  };

  vendorHash = "sha256-dBVrkTpeYtTVdA/BEcBGyBdSk3po7TQQwo0ux6qPK2Q=";

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
