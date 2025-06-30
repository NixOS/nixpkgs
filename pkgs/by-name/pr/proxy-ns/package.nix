#https://github.com/NixOS/nixpkgs/blob/nixos-25.05/pkgs/build-support/go/module.nix
{
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  lib,
}:
buildGoModule rec {
  name = "proxy-ns";
  version = "2.2.3";
  vendorHash = null;
  src = fetchFromGitHub {
    owner = "OkamiW";
    repo = name;
    rev = "v${version}";
    hash = "sha256-km+Rd3oXeyOX7wCoLL9f67AU/AVZTuGlvU0jtgTvgJE=";
  };
  ldflags = [
    "-s"
    "-w"
  ];
  GOFLAGS = [
    "-buildvcs=false"
    #"-trimpath" added by default by buildGoModule
  ];
  env.CGO_ENABLED = 0;
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Linux-specific command-line tool that can force any program to use your SOCKS5 proxy server.";
    mainProgram = "proxy-ns";
    homepage = "https://github.com/OkamiW/proxy-ns";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ deng232 ];
  };
}
