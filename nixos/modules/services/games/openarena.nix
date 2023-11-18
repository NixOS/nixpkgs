{ config, lib, pkgs, ... }:

let
  inherit (lib) concatStringsSep mkEnableOption mkIf mkOption types;
  cfg = config.services.openarena;
in
{
  options = {
    services.openarena = {
      enable = mkEnableOption (lib.mdDoc "OpenArena");
      package = lib.mkPackageOptionMD pkgs "openarena" { };

      openPorts = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to open firewall ports for OpenArena";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc "Extra flags to pass to {command}`oa_ded`";
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
        ExecStart = "${cfg.package}/bin/oa_ded +set fs_basepath ${cfg.package}/share/openarena +set fs_homepath /var/lib/openarena ${concatStringsSep " " cfg.extraFlags}";
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateDevices = true;
      };
    };
  };
}
