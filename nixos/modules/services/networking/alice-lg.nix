{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.alice-lg;
  settingsFormat = pkgs.formats.ini { };
in
{
  options = {
    services.alice-lg = {
      enable = mkEnableOption "Alice Looking Glass";

      package = mkPackageOption pkgs "alice-lg" { };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        description = ''
          alice-lg configuration, for configuration options see the example on [github](https://github.com/alice-lg/alice-lg/blob/main/etc/alice-lg/alice.example.conf)
        '';
        example = literalExpression ''
          {
            server = {
              # configures the built-in webserver and provides global application settings
              listen_http = "127.0.0.1:7340";
              enable_prefix_lookup = true;
              asn = 9033;
              store_backend = postgres;
              routes_store_refresh_parallelism = 5;
              neighbors_store_refresh_parallelism = 10000;
              routes_store_refresh_interval = 5;
              neighbors_store_refresh_interval = 5;
            };
            postgres = {
              url = "postgres://postgres:postgres@localhost:5432/alice";
              min_connections = 2;
              max_connections = 128;
            };
            pagination = {
              routes_filtered_page_size = 250;
              routes_accepted_page_size = 250;
              routes_not_exported_page_size = 250;
            };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc."alice-lg/alice.conf".source = settingsFormat.generate "alice-lg.conf" cfg.settings;
    };
    systemd.services = {
      alice-lg = {
        wants = [ "network.target" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "Alice Looking Glass";
        serviceConfig = {
          DynamicUser = true;
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 15;
          ExecStart = "${cfg.package}/bin/alice-lg";
          StateDirectoryMode = "0700";
          UMask = "0007";
          CapabilityBoundingSet = "";
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_INET AF_INET6" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "~@clock @privileged @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @setuid @swap";
          BindReadOnlyPaths = [
            "-/etc/resolv.conf"
            "-/etc/nsswitch.conf"
            "-/etc/ssl/certs"
            "-/etc/static/ssl/certs"
            "-/etc/hosts"
            "-/etc/localtime"
          ];
        };
      };
    };
  };
}
