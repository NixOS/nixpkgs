{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.what;
in {
  meta.maintainers = with maintainers; [ filalex77 ];

  options = {
    programs.what = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add what to the global environment and configure a
          setcap wrapper for it.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ what ];
    security.wrappers.what = {
      source = "${pkgs.what}/bin/what";
      capabilities = "cap_net_raw,cap_net_admin+ep";
    };
  };
}
