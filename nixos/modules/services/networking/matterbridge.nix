{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.matterbridge;

  matterbridgeConfToml = pkgs.writeText "matterbridge.toml" (cfg.configFile);

in

{
  options = {
    services.matterbridge = {
      enable = mkEnableOption "Matterbridge chat platform bridge";

      configFile = mkOption {
        type = types.str;
        example = ''
          #WARNING: as this file contains credentials, be sure to set correct file permissions          [irc]
              [irc.freenode]
              Server="irc.freenode.net:6667"
              Nick="matterbot"

          [mattermost]
              [mattermost.work]
               #do not prefix it wit http:// or https://
               Server="yourmattermostserver.domain"
               Team="yourteam"
               Login="yourlogin"
               Password="yourpass"
               PrefixMessagesWithNick=true

          [[gateway]]
          name="gateway1"
          enable=true
              [[gateway.inout]]
              account="irc.freenode"
              channel="#testing"

              [[gateway.inout]]
              account="mattermost.work"
              channel="off-topic"
        '';
        description = ''
          The matterbridge configuration file in the TOML file format.
        '';
      };
      user = mkOption {
        type = types.str;
        default = "matterbridge";
        description = ''
          User which runs the matterbridge service.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "matterbridge";
        description = ''
          Group which runs the matterbridge service.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {

      users.extraUsers = mkIf (cfg.user == "matterbridge") [
        { name = "matterbridge";
          group = "matterbridge";
        } ];

      users.extraGroups = mkIf (cfg.group == "matterbridge") [
        { name = "matterbridge";
        } ];

      systemd.services.matterbridge = {
        description = "Matterbridge chat platform bridge";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${pkgs.matterbridge.bin}/bin/matterbridge -conf ${matterbridgeConfToml}";
          Restart = "always";
          RestartSec = "10";
        };
      };
    })
  ];
}

