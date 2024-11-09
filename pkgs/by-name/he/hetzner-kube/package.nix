{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hetzner-kube";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "xetys";
    repo = "hetzner-kube";
    rev = version;
    hash = "sha256-XHvR+31yq0o3txMBHh2rCh2peDlG5Kh3hdl0LGm9D8c=";
  };

  patches = [
    # Use $HOME instead of the OS user database.
    # Upstream PR: https://github.com/xetys/hetzner-kube/pull/346
    # Unfortunately, the PR patch does not apply against release.
    ./fix-home.patch
  ];

  vendorHash = "sha256-sIjSu9U+uNc5dgt9Qg328W/28nX4F5d5zjUb7Y1xAso=";

  doCheck = false;

  ldflags = [
    "-X github.com/xetys/hetzner-kube/cmd.version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    # Need a writable home, because it fails if unable to write config.
    export HOME=$TMP
    $out/bin/hetzner-kube completion bash > hetzner-kube
    $out/bin/hetzner-kube completion zsh > _hetzner-kube
    installShellCompletion --zsh _hetzner-kube
    installShellCompletion --bash hetzner-kube
  '';

  meta = {
    description = "CLI tool for provisioning Kubernetes clusters on Hetzner Cloud";
    mainProgram = "hetzner-kube";
    homepage = "https://github.com/xetys/hetzner-kube";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eliasp ];
  };
}
