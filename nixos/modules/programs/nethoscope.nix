{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.nethoscope;
in
{
  meta.maintainers = with maintainers; [ _0x4A6F ];

  options = {
    programs.nethoscope = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to add nethoscope to the global environment and configure a
          setcap wrapper for it.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nethoscope ];
    security.wrappers.nethoscope = {
      source = "${pkgs.nethoscope}/bin/nethoscope";
      capabilities = "cap_net_raw,cap_net_admin=eip";
    };
  };
}
