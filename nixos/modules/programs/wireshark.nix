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
        description = lib.mdDoc ''
          Whether to add Wireshark to the global environment and configure a
          setcap wrapper for 'dumpcap' for users in the 'wireshark' group.
        '';
      };
      package = mkPackageOption pkgs "wireshark-cli" {
        example = "wireshark";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ wireshark ];
    users.groups.wireshark = {};

    security.wrappers.dumpcap = {
      source = "${wireshark}/bin/dumpcap";
      capabilities = "cap_net_raw,cap_net_admin+eip";
      owner = "root";
      group = "wireshark";
      permissions = "u+rx,g+x";
    };
  };
}
