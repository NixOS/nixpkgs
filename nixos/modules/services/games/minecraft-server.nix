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
          <literal>/var/lib/minecraft</literal>.
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
    users.extraUsers.minecraft = {
      description     = "Minecraft Server Service user";
      home            = "/var/lib/minecraft";
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
        cd /var/lib/minecraft
        exec ${pkgs.minecraft-server}/bin/minecraft-server ${cfg.jvmOpts}
      '';
    };
  };
}
