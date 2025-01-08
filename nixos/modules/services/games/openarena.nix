{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.openarena;
in
{
  options = {
    services.openarena = {
      enable = lib.mkEnableOption "OpenArena game server";
      package = lib.mkPackageOption pkgs "openarena" { };

      openPorts = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open firewall ports for OpenArena";
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra flags to pass to {command}`oa_ded`";
        example = [
          "+set dedicated 2"
          "+set sv_hostname 'My NixOS OpenArena Server'"
          # Load a map. Mandatory for clients to be able to connect.
          "+map oa_dm1"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openPorts {
      allowedUDPPorts = [ 27960 ];
    };

    systemd.services.openarena = {
      description = "OpenArena";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "openarena";
        ExecStart = "${cfg.package}/bin/oa_ded +set fs_basepath ${cfg.package}/share/openarena +set fs_homepath /var/lib/openarena ${lib.concatStringsSep " " cfg.extraFlags}";
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateDevices = true;
      };
    };
  };
}
