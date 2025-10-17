{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo125Module (finalAttrs: {
  pname = "chezmoi";
  version = "2.66.0";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r49KRq6PIB6gRnudY9HMm0UBjd07J6tUpA3oTOyJzGI=";
  };

  vendorHash = "sha256-ioRFzkp4aSUdPq3NSKDj05DbTp6PwAjVkf7VtdpaI2w=";

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.builtBy=nixpkgs"
  ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --bash --name chezmoi.bash completions/chezmoi-completion.bash
    installShellCompletion --fish completions/chezmoi.fish
    installShellCompletion --zsh completions/chezmoi.zsh
  '';

  meta = {
    description = "Manage your dotfiles across multiple machines, securely";
    homepage = "https://www.chezmoi.io/";
    changelog = "https://github.com/twpayne/chezmoi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "chezmoi";
  };
})
