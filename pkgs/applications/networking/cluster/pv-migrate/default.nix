{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "pv-migrate";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mTzVMO0Msk5q8Wnpb0iQ8kifhNXlp4MfM+irMmOLDv8=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-SyORFCfX/4dhYLnsE/lc21/18TKpLkOxz+W9lsHjKNE=";

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
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/${version}";
    license = licenses.afl20;
    maintainers = with lib.maintainers; [ ivankovnatsky qjoly ];
  };
}
