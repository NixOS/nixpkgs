{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
}:

buildGoModule rec {
  pname = "g-ls";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "Equationzhao";
    repo = "g";
    rev = "v${version}";
    hash = "sha256-nQzeMlJwvGUAX53QRe4zcRx8OoTu65uHpmD2vkPkJac=";
  };

  vendorHash = "sha256-pAr/A731tzrWsCogaXD4fVSdC4kF+B2E+QXOSjHU18g=";

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
    license = lib.licenses.mit;
    mainProgram = "g";
    maintainers = with lib.maintainers; [ Ruixi-rebirth ];
  };
}
