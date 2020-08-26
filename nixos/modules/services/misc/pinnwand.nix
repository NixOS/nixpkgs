{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pinnwand;

  format = pkgs.formats.toml {};
  configFile = format.generate "pinnwand.toml" cfg.settings;
in
{
  options.services.pinnwand = {
    enable = mkEnableOption "Pinnwand";

    port = mkOption {
      type = types.port;
      description = "The port to listen on.";
      default = 8000;
    };

    settings = mkOption {
      type = format.type;
      description = ''
        Your <filename>pinnwand.toml</filename> as a Nix attribute set. Look up
        possible options in the <link xlink:href="https://github.com/supakeen/pinnwand/blob/master/pinnwand.toml-example">pinnwand.toml-example</link>.
      '';
      default = {
        # https://github.com/supakeen/pinnwand/blob/master/pinnwand.toml-example
        database_uri = "sqlite:///var/lib/pinnwand/pinnwand.db";
        preferred_lexeres = [];
        paste_size = 262144;
        paste_help = ''
          <p>Welcome to pinnwand, this site is a pastebin. It allows you to share code with others. If you write code in the text area below and press the paste button you will be given a link you can share with others so they can view your code as well.</p><p>People with the link can view your pasted code, only you can remove your paste and it expires automatically. Note that anyone could guess the URI to your paste so don't rely on it being private.</p>
        '';
        footer = ''
          View <a href="//github.com/supakeen/pinnwand" target="_BLANK">source code</a>, the <a href="/removal">removal</a> or <a href="/expiry">expiry</a> stories, or read the <a href="/about">about</a> page.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pinnwand = {
      description = "Pinnwannd HTTP Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig.Documentation = "https://pinnwand.readthedocs.io/en/latest/";
      serviceConfig = {
        ExecStart = "${pkgs.pinnwand}/bin/pinnwand --configuration-path ${configFile} http --port ${toString(cfg.port)}";
        StateDirectory = "pinnwand";
        StateDirectoryMode = "0700";

        AmbientCapabilities = [];
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "0077";
      };
    };
  };
}
