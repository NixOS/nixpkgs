{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "pv-migrate";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QD/yacQOII1AS9VHB/2cTgoxLioyKYoROSizkHooX9w=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-NXL7LaGSfiJW9lQrZyh5Iw1QvQ9T8omfafADm4PlGik=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.commit=${src.rev}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd pv-migrate \
      --bash <($out/bin/pv-migrate completion bash) \
      --fish <($out/bin/pv-migrate completion fish) \
      --zsh <($out/bin/pv-migrate completion zsh)
  '';

  meta = with lib; {
    description = "CLI tool to easily migrate Kubernetes persistent volumes ";
    mainProgram = "pv-migrate";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = with lib.maintainers; [
      ivankovnatsky
      qjoly
    ];
  };
}
