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
        description = ''
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
              [irc.freenode]
              Server="irc.freenode.net:6667"
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
              account="irc.freenode"
              channel="#testing"

              [[gateway.inout]]
              account="mattermost.work"
              channel="off-topic"
        '';
        description = ''
          WARNING: THIS IS INSECURE, as your password will end up in
          <filename>/nix/store</filename>, thus publicly readable. Use
          <literal>services.matterbridge.configPath</literal> instead.

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
        ExecStart = "${pkgs.matterbridge.bin}/bin/matterbridge -conf ${matterbridgeConfToml}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
