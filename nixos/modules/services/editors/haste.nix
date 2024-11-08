{ config, lib, pkgs, ... }:
let
  pkg = pkgs.haste-server;
  cfg = config.services.haste-server;

  format = pkgs.formats.json {};
in
{
  options.services.haste-server = {
    enable = lib.mkEnableOption "haste-server";
    openFirewall = lib.mkEnableOption "firewall passthrough for haste-server";

    settings = lib.mkOption {
      description = ''
        Configuration for haste-server.
        For documentation see [project readme](https://github.com/toptal/haste-server#settings)
      '';
      type = format.type;
    };
  };

  config = lib.mkIf (cfg.enable) {
    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.openFirewall) [ cfg.settings.port ];

    services.haste-server = {
      settings = {
        host = lib.mkDefault "::";
        port = lib.mkDefault 7777;

        keyLength = lib.mkDefault 10;
        maxLength = lib.mkDefault 400000;

        staticMaxAge = lib.mkDefault 86400;
        recompressStaticAssets = lib.mkDefault false;

        logging = lib.mkDefault [
          {
            level = "verbose";
            type = "Console";
            colorize = true;
          }
        ];

        keyGenerator = lib.mkDefault {
          type = "phonetic";
        };

        rateLimits = {
          categories = {
            normal = {
              totalRequests = lib.mkDefault 500;
              every = lib.mkDefault 60000;
            };
          };
        };

        storage = lib.mkDefault {
          type = "file";
        };

        documents = {
          about = lib.mkDefault "${pkg}/share/haste-server/about.md";
        };
      };
    };

    systemd.services.haste-server = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = "haste-server";
        DynamicUser = true;
        StateDirectory = "haste-server";
        WorkingDirectory = "/var/lib/haste-server";
        ExecStart = "${pkg}/bin/haste-server ${format.generate "config.json" cfg.settings}";
      };

      path = with pkgs; [ pkg coreutils ];
    };
  };
}
