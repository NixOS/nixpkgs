{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.minecraft-server;
in
{
  options = {
    services.minecraft-server = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, start a Minecraft Server. The listening port for
          the server is always <literal>25565</literal>. The server
          data will be loaded from and saved to
          <literal>${cfg.dataDir}</literal>.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/minecraft";
        description = ''
          Directory to store minecraft database and other state/data files.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall (if enabled) for the server.
        '';
      };

      jvmOpts = mkOption {
        type = types.str;
        default = "-Xmx2048M -Xms2048M";
        description = "JVM options for the Minecraft Service.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.minecraft = {
      description     = "Minecraft Server Service user";
      home            = cfg.dataDir;
      createHome      = true;
      uid             = config.ids.uids.minecraft;
    };

    systemd.services.minecraft-server = {
      description   = "Minecraft Server Service";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig.Restart = "always";
      serviceConfig.User    = "minecraft";
      script = ''
        cd ${cfg.dataDir}
        exec ${pkgs.minecraft-server}/bin/minecraft-server ${cfg.jvmOpts}
      '';
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedUDPPorts = [ 25565 ];
      allowedTCPPorts = [ 25565 ];
    };
  };
}
