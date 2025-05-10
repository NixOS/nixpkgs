{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  argset = {
    pname = "chezmoi";
    version = "2.62.2";

    src = fetchFromGitHub {
      owner = "twpayne";
      repo = "chezmoi";
      rev = "v${argset.version}";
      hash = "sha256-Bma7w/Nhpht02eOVyVJDJq+JDUXR7svD8TdMZhuNw10=";
    };

    vendorHash = "sha256-L089chsoaEDo2+ahTKs9w0Np3S2fWVtt9jWRJmBrP3w=";

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
      maintainers = with lib.maintainers; [ ];
    };
  };
in
buildGoModule argset
