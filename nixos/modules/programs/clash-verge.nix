{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.clash-verge;

  clash-verge-package = pkgs.clash-verge.overrideAttrs (finalAttrs: previousAttrs: {
    installPhase = ''
      runHook preInstall
      mv usr $out
      mv $out/bin/clash-meta $out/bin/clash-meta-origin
      mv $out/bin/clash $out/bin/clash-origin
      ln -s /run/wrappers/bin/clash-meta $out/bin/clash-meta
      ln -s /run/wrappers/bin/clash $out/bin/clash
      runHook postInstall
    '';
  });
in
{
  # interface
  options.programs.clash-verge = {
    enable = mkEnableOption (lib.mdDoc "clash-verge");
  };

  # implementation

  config = mkIf cfg.enable {
    assertions = [
    ];
    security.wrappers.clash-meta = {
      source = "${clash-verge-package.out}/bin/clash-meta-origin";
      capabilities = "cap_net_bind_service,cap_net_admin=+ep";
      owner = "root";
      group = "root";
    };
    security.wrappers.clash = {
      source = "${clash-verge-package.out}/bin/clash-meta-origin";
      capabilities = "cap_net_bind_service,cap_net_admin=+ep";
      owner = "root";
      group = "root";
    };
    environment.systemPackages = [ clash-verge-package ];
  };
}
