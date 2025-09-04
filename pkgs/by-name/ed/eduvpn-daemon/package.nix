{
  lib,
  buildGoModule,
  fetchFromGitea,
  nix-update-script,
}:

buildGoModule rec {
  pname = "eduvpn-daemon";
  version = "3.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eduVPN";
    repo = "vpn-daemon";
    tag = version;
    hash = "sha256-tRdXc5sP8yInRMn6HFUf17ABIV1/mhugCH++TxuLcBw=";
  };

  vendorHash = "sha256-KcLwKZFg9e6eLFoYFiE7DpPN7wQa5wNl8+5B3MDe8S4=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenVPN & WireGuard Management Daemon";
    homepage = "https://${src.domain}/${src.owner}/${src.repo}";
    license = lib.licenses.mit;
    changelog = "https://${src.domain}/${src.owner}/${src.repo}/src/tag/${version}/CHANGES.md";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      m0ustach3
    ];
    mainProgram = "vpn-daemon";
  };
}
