{ config, lib, pkgs, ... }:

let
  cfg = config.programs.wireshark;
  wireshark = cfg.package;
in {
  options = {
    programs.wireshark = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to add Wireshark to the global environment and configure a
          setcap wrapper for 'dumpcap' for users in the 'wireshark' group.
        '';
      };
      package = lib.mkPackageOption pkgs "wireshark-cli" {
        example = "wireshark";
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
