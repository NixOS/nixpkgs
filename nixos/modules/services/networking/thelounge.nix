{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.services.thelounge;
  dataDir = "/var/lib/thelounge";
  configJsData = "module.exports = " + builtins.toJSON (
    { public = cfg.public; port = cfg.port; } // cfg.extraConfig
  );
in
{
  options.services.thelounge = {
    enable = mkEnableOption "The Lounge web IRC client";

    public = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Make your The Lounge instance public.
        Anyone can connect to IRC networks in this mode.
        All IRC connections and channel scrollbacks are lost when a user leaves the client.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 9000;
      description = "TCP port to listen on for http connections.";
    };

    extraConfig = mkOption {
      default = { };
      type = types.attrs;
      example = literalExample ''{
        reverseProxy = true;
        defaults = {
          name = "Your Network";
          host = "localhost";
          port = 6697;
        };
      }'';
      description = ''
        The Lounge's <filename>config.js</filename> contents as attribute set (will be
        converted to JSON to generate the configuration file).

        The options defined here will be merged to the default configuration file.
        Note: In case of duplicate configuration, options from <option>extraConfig</option> have priority.

        Documentation: <link xlink:href="https://thelounge.chat/docs/server/configuration" />
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.thelounge = {
      description = "thelounge service user";
      group = "thelounge";
      isSystemUser = true;
    };
    users.groups.thelounge = { };
    systemd.services.thelounge = {
      description = "The Lounge web IRC client";
      wantedBy = [ "multi-user.target" ];
      preStart = "ln -sf ${pkgs.writeText "config.js" configJsData} ${dataDir}/config.js";
      serviceConfig = {
        User = "thelounge";
        StateDirectory = baseNameOf dataDir;
        ExecStart = "${pkgs.thelounge}/bin/thelounge start";
      };
    };

    environment.systemPackages = [ pkgs.thelounge ];
  };
}
