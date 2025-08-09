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
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "kompose";
    rev = "v${version}";
    hash = "sha256-OnVJkAZqN0/V0tHtDpsZDN2gIvEpI5z2Pv0lspr6ZTg=";
  };

  vendorHash = "sha256-UQnhakHAyldESYhQlHe5mHVv5jFB7DUp+mNo0Q0iDkc=";

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
