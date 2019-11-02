{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.openarena;
in
{
  options = {
    services.openarena = {
      enable = mkEnableOption "OpenArena";

      openPorts = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open firewall ports for OpenArena";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''Extra flags to pass to <command>oa_ded</command>'';
        example = [
          "+set dedicated 2"
          "+set sv_hostname 'My NixOS OpenArena Server'"
          # Load a map. Mandatory for clients to be able to connect.
          "+map oa_dm1"
        ];
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openPorts {
      allowedUDPPorts = [ 27960 ];
    };

    systemd.services.openarena = {
      description = "OpenArena";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "openarena";
        ExecStart = "${pkgs.openarena}/bin/openarena-server +set fs_basepath ${pkgs.openarena}/openarena-0.8.8 +set fs_homepath /var/lib/openarena ${concatStringsSep " " cfg.extraFlags}";
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateDevices = true;
      };
    };
  };
}
