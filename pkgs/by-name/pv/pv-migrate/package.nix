{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "pv-migrate";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-41yuxvGsJ+BTvw96hWhVRqqJ1UXhvqGO9Y0hU7PfjTU=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-bkyANbdQIsb8XHRQvI//RogFfVr7x6wwsieru1KIppU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.commit=v${version}"
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

  meta = {
    mainProgram = "pv-migrate";
    description = "CLI tool to easily migrate Kubernetes persistent volumes";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/v${version}";
    license = lib.licenses.afl20;
    maintainers = with lib.maintainers; [
      ivankovnatsky
      qjoly
    ];
  };
}
