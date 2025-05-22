{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  argset = {
    pname = "chezmoi";
    version = "2.62.4";

    src = fetchFromGitHub {
      owner = "twpayne";
      repo = "chezmoi";
      rev = "v${argset.version}";
      hash = "sha256-GVUPW5zEuactbonqdJhn0C+Ru2v0J883Waj+IgaConQ=";
    };

    vendorHash = "sha256-rTrA0ZoHWl2yL+4Wv+SkyJy6cw0cg4BGHMrZsMDVH38=";

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
