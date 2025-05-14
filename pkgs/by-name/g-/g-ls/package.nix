{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
}:

buildGoModule rec {
  pname = "g-ls";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "Equationzhao";
    repo = "g";
    tag = "v${version}";
    hash = "sha256-OaYWorybwUxG452b0vEKwryxmRaNTQ5xDWe9GmEWuGE=";
  };

  vendorHash = "sha256-E/4iB1apLCOEtijCZymObz0Zjlf0+dQC37ALSbl1tr0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      --bash completions/bash/g-completion.bash \
      --zsh completions/zsh/_g \
      --fish completions/fish/g.fish
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Powerful ls alternative written in Go";
    homepage = "https://github.com/Equationzhao/g";
    changelog = "https://github.com/Equationzhao/g/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "g";
    maintainers = with lib.maintainers; [ Ruixi-rebirth ];
  };
}
