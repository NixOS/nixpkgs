{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  argset = {
    pname = "chezmoi";
    version = "2.48.2";

    src = fetchFromGitHub {
      owner = "twpayne";
      repo = "chezmoi";
      rev = "v${argset.version}";
      hash = "sha256-Ikxp8PJ72UCRYmaoloruVdIpi46nF41bi7RK0rPvs1E=";
    };

    vendorHash = "sha256-151l+yen1QI5DiYJgBvWV/OlbnE72ecmMtHUBRhxQM4=";

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
