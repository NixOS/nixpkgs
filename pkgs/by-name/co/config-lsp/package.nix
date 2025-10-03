{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule rec {
  pname = "config-lsp";
  version = "0.3.2";

  src =
    fetchFromGitea {
      domain = "git.myzel394.app";
      owner = "Myzel394";
      repo = "config-lsp";
      tag = "v${version}";
      hash = "sha256-CwE/nOPZjG2QNo9+1NCI+tkVC5wdpZS05a8vy5LfXkY=";
    }
    + "/server";

  vendorHash = "sha256-17DqJvc8KKnyqO7vsJoBgYYBCa0boua2rpsMHZ5esmM=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Finally a LSP for your config files: gitconfig, fstab, aliases, hosts, wireguard, ssh_config, sshd_config, and more to come!";
    homepage = "https://git.myzel394.app/Myzel394/config-lsp";
    platforms = lib.platforms.all;
    maintainers = with maintainers; [ myzel394 ];
    mainProgram = "config-lsp";
  };
}
