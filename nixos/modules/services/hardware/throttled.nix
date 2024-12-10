{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.throttled;
in
{
  options = {
    services.throttled = {
      enable = mkEnableOption "fix for Intel CPU throttling";

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Alternative configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.throttled ];
    # The upstream package has this in Install, but that's not enough, see the NixOS manual
    systemd.services.throttled.wantedBy = [ "multi-user.target" ];

    environment.etc."throttled.conf".source =
      if cfg.extraConfig != "" then
        pkgs.writeText "throttled.conf" cfg.extraConfig
      else
        "${pkgs.throttled}/etc/throttled.conf";

    hardware.cpu.x86.msr.enable = true;
    # Kernel 5.9 spams warnings whenever userspace writes to CPU MSRs.
    # See https://github.com/erpalma/throttled/issues/215
    hardware.cpu.x86.msr.settings.allow-writes =
      mkIf (versionAtLeast config.boot.kernelPackages.kernel.version "5.9") "on";
  };
}
