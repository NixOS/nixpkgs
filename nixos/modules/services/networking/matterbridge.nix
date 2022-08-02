{ options, config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.matterbridge;

  matterbridgeConfToml =
    if cfg.configPath == null then
      pkgs.writeText "matterbridge.toml" (cfg.configFile)
    else
      cfg.configPath;

in

{
  options = {
    services.matterbridge = {
      enable = mkEnableOption "Matterbridge chat platform bridge";

      configPath = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "/etc/nixos/matterbridge.toml";
        description = lib.mdDoc ''
          The path to the matterbridge configuration file.
        '';
      };

      configFile = mkOption {
        type = types.str;
        example = ''
          # WARNING: as this file contains credentials, do not use this option!
          # It is kept only for backwards compatibility, and would cause your
          # credentials to be in the nix-store, thus with the world-readable
          # permission bits.
          # Use services.matterbridge.configPath instead.

          [irc]
              [irc.libera]
              Server="irc.libera.chat:6667"
              Nick="matterbot"

          [mattermost]
              [mattermost.work]
               # Do not prefix it with http:// or https://
               Server="yourmattermostserver.domain"
               Team="yourteam"
               Login="yourlogin"
               Password="yourpass"
               PrefixMessagesWithNick=true

          [[gateway]]
          name="gateway1"
          enable=true
              [[gateway.inout]]
              account="irc.libera"
              channel="#testing"

              [[gateway.inout]]
              account="mattermost.work"
              channel="off-topic"
        '';
        description = lib.mdDoc ''
          WARNING: THIS IS INSECURE, as your password will end up in
          {file}`/nix/store`, thus publicly readable. Use
          `services.matterbridge.configPath` instead.

          The matterbridge configuration file in the TOML file format.
        '';
      };
      user = mkOption {
        type = types.str;
        default = "matterbridge";
        description = lib.mdDoc ''
          User which runs the matterbridge service.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "matterbridge";
        description = lib.mdDoc ''
          Group which runs the matterbridge service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    warnings = optional options.services.matterbridge.configFile.isDefined
      "The option services.matterbridge.configFile is insecure and should be replaced with services.matterbridge.configPath";

    users.users = optionalAttrs (cfg.user == "matterbridge")
      { matterbridge = {
          group = "matterbridge";
          isSystemUser = true;
        };
      };

    users.groups = optionalAttrs (cfg.group == "matterbridge")
      { matterbridge = { };
      };

    systemd.services.matterbridge = {
      description = "Matterbridge chat platform bridge";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.matterbridge}/bin/matterbridge -conf ${matterbridgeConfToml}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
