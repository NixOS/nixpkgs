{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "config-lsp";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "Myzel394";
    repo = "config-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hyz96QChFXmlsC3TIsXJ/+PIx+OdhbipGw9fAHAdnrg=";
  };

  sourceRoot = "${finalAttrs.src.name}/server";

  vendorHash = "sha256-17DqJvc8KKnyqO7vsJoBgYYBCa0boua2rpsMHZ5esmM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Finally an LSP for your config files: fstab, aliases, hosts, wireguard, ssh_config, sshd_config";
    homepage = "https://github.com/Myzel394/config-lsp";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ myzel394 ];
    mainProgram = "config-lsp";
  };
})
