{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "g-ls";
  version = "0.31.2";

  src = fetchFromGitHub {
    owner = "Equationzhao";
    repo = "g";
    tag = "v${finalAttrs.version}";
    hash = "sha256-krir/F+USTbVRFwC7d2rA5d4EcOG+2CNpwSqCUJP5fU=";
  };

  vendorHash = "sha256-j1zsulX1wySlWivVU9ajJFmx8Ww2/sxVMV41fUJa1DU=";

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
    changelog = "https://github.com/Equationzhao/g/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "g";
    maintainers = with lib.maintainers; [ Ruixi-rebirth ];
  };
})
