{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ankisyncd;

  name = "ankisyncd";

  stateDir = "/var/lib/${name}";

  toml = pkgs.formats.toml {};

  configFile = toml.generate "ankisyncd.conf" {
    listen = {
      host = cfg.host;
      port = cfg.port;
    };
    paths.root_dir = stateDir;
    # encryption.ssl_enable / cert_file / key_file
  };
in
  {
    options.services.ankisyncd = {
      enable = mkEnableOption (lib.mdDoc "ankisyncd");

      package = mkOption {
        type = types.package;
        default = pkgs.ankisyncd;
        defaultText = literalExpression "pkgs.ankisyncd";
        description = lib.mdDoc "The package to use for the ankisyncd command.";
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "ankisyncd host";
      };

      port = mkOption {
        type = types.port;
        default = 27701;
        description = lib.mdDoc "ankisyncd port";
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to open the firewall for the specified port.";
      };
    };

    config = mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

      systemd.services.ankisyncd = {
        description = "ankisyncd - Anki sync server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ cfg.package ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = name;
          ExecStart = "${cfg.package}/bin/ankisyncd --config ${configFile}";
          Restart = "always";
        };
      };
    };
  }
