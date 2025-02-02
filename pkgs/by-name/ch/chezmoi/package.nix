{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  argset = {
    pname = "chezmoi";
    version = "2.58.0";

    src = fetchFromGitHub {
      owner = "twpayne";
      repo = "chezmoi";
      rev = "v${argset.version}";
      hash = "sha256-qYu6V57SHMcOpcpJrDyX6jBSMaH2NOFbLReWoeutx5k=";
    };

    vendorHash = "sha256-jFsrGB7zC4LJNV4CpW/3JLrDIxtD4q7sBbY9gldEleU=";

    nativeBuildInputs = [
      installShellFiles
    ];

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${argset.version}"
      "-X main.builtBy=nixpkgs"
    ];

    doCheck = false;

    postInstall = ''
      installShellCompletion --bash --name chezmoi.bash completions/chezmoi-completion.bash
      installShellCompletion --fish completions/chezmoi.fish
      installShellCompletion --zsh completions/chezmoi.zsh
    '';

    subPackages = [ "." ];

    meta = {
      homepage = "https://www.chezmoi.io/";
      description = "Manage your dotfiles across multiple machines, securely";
      changelog = "https://github.com/twpayne/chezmoi/releases/tag/${argset.src.rev}";
      license = lib.licenses.mit;
      mainProgram = "chezmoi";
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
buildGoModule argset
