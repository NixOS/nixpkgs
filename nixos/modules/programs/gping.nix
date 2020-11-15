{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface
  options = {
    programs.gping = {
      enable = mkEnableOption "gping utility";
    };
  };

  ###### implementation
  config = mkIf config.programs.gping.enable {
    security.wrappers = {
      ping = {
        source = "${pkgs.gping.out}/bin/gping";
        owner = "nobody";
        group = "nogroup";
        capabilities = "cap_net_raw+ep";
      };
    };
  };
}
