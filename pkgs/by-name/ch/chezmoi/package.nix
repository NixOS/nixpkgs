{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo125Module (finalAttrs: {
  pname = "chezmoi";
  version = "2.65.0";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-neUltKkmNUtTajTwfWIIM9sJfDSXuAqJT3uLq6vR5NE=";
  };

  vendorHash = "sha256-NQ7k9bydAJDOGRX3bvRGkX5FuU8Va1IjUa6h0JEiLzo=";

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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "chezmoi";
  };
})
