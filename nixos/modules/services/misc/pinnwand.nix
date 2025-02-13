{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pinnwand;

  format = pkgs.formats.toml { };
  configFile = format.generate "pinnwand.toml" cfg.settings;
in
{
  options.services.pinnwand = {
    enable = lib.mkEnableOption "Pinnwand, a pastebin";

    port = lib.mkOption {
      type = lib.types.port;
      description = "The port to listen on.";
      default = 8000;
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Your {file}`pinnwand.toml` as a Nix attribute set. Look up
        possible options in the [documentation](https://pinnwand.readthedocs.io/en/v${pkgs.pinnwand.version}/configuration.html).
      '';
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          database_uri = lib.mkOption {
            type = lib.types.str;
            default = "sqlite:////var/lib/pinnwand/pinnwand.db";
            example = "sqlite:///:memory";
            description = ''
              Database URI compatible with [SQLAlchemy](https://docs.sqlalchemy.org/en/14/core/engines.html#database-urls).

              Additional packages may need to be introduced into the environment for certain databases.
            '';
          };

          paste_size = lib.mkOption {
            type = lib.types.ints.positive;
            default = 262144;
            example = 524288;
            description = ''
              Maximum size of a paste in bytes.
            '';
          };
          paste_help = lib.mkOption {
            type = lib.types.str;
            default = ''
              <p>Welcome to pinnwand, this site is a pastebin. It allows you to share code with others. If you write code in the text area below and press the paste button you will be given a link you can share with others so they can view your code as well.</p><p>People with the link can view your pasted code, only you can remove your paste and it expires automatically. Note that anyone could guess the URI to your paste so don't rely on it being private.</p>
            '';
            description = ''
              Raw HTML help text shown in the header area.
            '';
          };
          footer = lib.mkOption {
            type = lib.types.str;
            default = ''
              View <a href="//github.com/supakeen/pinnwand" target="_BLANK">source code</a>, the <a href="/removal">removal</a> or <a href="/expiry">expiry</a> stories, or read the <a href="/about">about</a> page.
            '';
            description = ''
              The footer in raw HTML.
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.pinnwand = {
      description = "Pinnwannd HTTP Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig.Documentation = "https://pinnwand.readthedocs.io/en/latest/";

      serviceConfig = {
        ExecStart = "${pkgs.pinnwand}/bin/pinnwand --configuration-path ${configFile} http --port ${toString cfg.port}";
        User = "pinnwand";
        DynamicUser = true;

        StateDirectory = "pinnwand";
        StateDirectoryMode = "0700";

        AmbientCapabilities = [ ];
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };

  meta.buildDocsInSandbox = false;
}
