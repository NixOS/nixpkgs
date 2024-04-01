{ config, lib, pkgs, ... }:

with lib;

let
  pkg = pkgs.haste-server;
  cfg = config.services.haste-server;

  format = pkgs.formats.json {};
in
{
  options.services.haste-server = {
    enable = mkEnableOption "haste-server";
    openFirewall = mkEnableOption "firewall passthrough for haste-server";

    settings = mkOption {
      description = lib.mdDoc ''
        Configuration for haste-server.
        For documentation see [project readme](https://github.com/toptal/haste-server#settings)
      '';
      type = format.type;
    };
  };

  config = mkIf (cfg.enable) {
    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall) [ cfg.settings.port ];

    services.haste-server = {
      settings = {
        host = mkDefault "::";
        port = mkDefault 7777;

        keyLength = mkDefault 10;
        maxLength = mkDefault 400000;

        staticMaxAge = mkDefault 86400;
        recompressStaticAssets = mkDefault false;

        logging = mkDefault [
          {
            level = "verbose";
            type = "Console";
            colorize = true;
          }
        ];

        keyGenerator = mkDefault {
          type = "phonetic";
        };

        rateLimits = {
          categories = {
            normal = {
              totalRequests = mkDefault 500;
              every = mkDefault 60000;
            };
          };
        };

        storage = mkDefault {
          type = "file";
        };

        documents = {
          about = mkDefault "${pkg}/share/haste-server/about.md";
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
