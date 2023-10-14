{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.bandwhich;
in {
  meta.maintainers = with maintainers; [ Br1ght0ne ];

  options = {
    programs.bandwhich = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to add bandwhich to the global environment and configure a
          setcap wrapper for it.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bandwhich ];
    security.wrappers.bandwhich = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep";
      source = "${pkgs.bandwhich}/bin/bandwhich";
    };
  };
}
