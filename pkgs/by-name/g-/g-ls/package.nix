{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
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

  zshCompletion = fetchurl {
    url = "https://raw.githubusercontent.com/Equationzhao/g/v${version}/completions/zsh/_g";
    sha256 = "sha256-ICETDPReNIi0I3EaZWuNbj3YXRg8ihIRIAx3dVZDa/4=";
  };

  bashCompletion = fetchurl {
    url = "https://raw.githubusercontent.com/Equationzhao/g/v${version}/completions/bash/g-completion.bash";
    sha256 = "sha256-iVKvGKGe3X6SikbimFYttzriEHrzx2BQGXffEI48vk8=";
  };

  fishCompletion = fetchurl {
    url = "https://raw.githubusercontent.com/Equationzhao/g/v${version}/completions/fish/g.fish";
    sha256 = "sha256-Ub7zaT+O7v3XyVbRX6vYJ2XJkUoptfLLkHiKJZFE2A8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh ${zshCompletion}
    installShellCompletion --bash ${bashCompletion}
    installShellCompletion --fish ${fishCompletion}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A powerful ls alternative written in Go";
    homepage = "https://github.com/Equationzhao/g";
    license = lib.licenses.mit;
    mainProgram = "g";
    maintainers = with lib.maintainers; [ Ruixi-rebirth ];
  };
}
