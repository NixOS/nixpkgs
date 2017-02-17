{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.wireshark;
  wireshark = cfg.package;
in {
  options = {
    programs.wireshark = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add Wireshark to the global environment and configure a
          setcap wrapper for 'dumpcap'.
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
      capabilities = "cap_net_raw+p";
    };
  };
}
