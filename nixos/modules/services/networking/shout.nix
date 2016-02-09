{ pkgs, lib, config, options, ... }:

with lib;

let
  cfg = config.services.shout;
  shoutHome = "/var/lib/shout";

in {
  options.services.shout = {
    enable = mkEnableOption "Shout web IRC client";

    private = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Make your shout instance private. You will need to configure user
        accounts by adding entries in <filename>${shoutHome}/users</filename>.
      '';
    };

    listenAddress = mkOption {
      type = types.string;
      default = "0.0.0.0";
      description = "IP interface to listen on for http connections.";
    };

    port = mkOption {
      type = types.int;
      default = 9000;
      description = "TCP port to listen on for http connections.";
    };

    configFile = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Contents of Shout's <filename>config.js</filename> file. If left empty,
        Shout will generate from its defaults at first startup.

        Documentation: http://shout-irc.com/docs/server/configuration.html
      '';
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers = singleton {
      name = "shout";
      uid = config.ids.uids.shout;
      description = "Shout daemon user";
      home = shoutHome;
      createHome = true;
    };

    systemd.services.shout = {
      description = "Shout web IRC client";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      preStart = if isNull cfg.configFile then ""
                 else ''
                   ln -sf ${pkgs.writeText "config.js" cfg.configFile} \
                          ${shoutHome}/config.js
                 '';
      script = concatStringsSep " " [
        "${pkgs.shout}/bin/shout"
        (if cfg.private then "--private" else "--public")
        "--port" (toString cfg.port)
        "--host" (toString cfg.listenAddress)
        "--home" shoutHome
      ];
      serviceConfig = {
        User = "shout";
        ProtectHome = "true";
        ProtectSystem = "full";
        PrivateTmp = "true";
      };
    };
  };
}
