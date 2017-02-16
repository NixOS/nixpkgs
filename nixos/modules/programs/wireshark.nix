{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.wireshark;
  wireshark = cfg.package;

in

{

  options = {

    programs.wireshark = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add Wireshark to the global environment and configure a
          setuid wrapper for 'dumpcap' for users in the 'wireshark' group.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.wireshark-cli;
        defaultText = "pkgs.wireshark-cli";
        description = ''
          Which Wireshark package to install in the global environment.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ wireshark ];
    
    security.wrappers.dumpcap = {
      source = "${wireshark}/bin/dumpcap";
      owner = "root";
      group = "wireshark";
      setuid = true;
      setgid = false;
      permissions = "u+rx,g+x";
    };

    users.extraGroups.wireshark.gid = config.ids.gids.wireshark;

  };

}
