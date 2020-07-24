{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.bandwhich;
in {
  meta.maintainers = with maintainers; [ filalex77 ];

  options = {
    programs.bandwhich = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add bandwhich to the global environment and configure a
          setcap wrapper for it.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bandwhich ];
    security.wrappers.bandwhich = {
      source = "${pkgs.bandwhich}/bin/bandwhich";
      capabilities = "cap_net_raw,cap_net_admin+ep";
    };
  };
}
