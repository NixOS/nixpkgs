{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo125Module (finalAttrs: {
  pname = "chezmoi";
  version = "2.70.2";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-47tc3L3iUVt+i13qyZMxRYb59Y/id/+EMQfbZGsMJzQ=";
  };

  vendorHash = "sha256-uTbU8lrMTfyiljJ6flo88k3xJrhZJCzPuyu/hFrRTGo=";

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
