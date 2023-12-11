{ config
, pkgs
, lib
, ...}:

with lib;
let
  cfg = config.services.polaris;
  settingsFormat = pkgs.formats.toml {};
in
{
  options = {
    services.polaris = {
      enable = mkEnableOption (lib.mdDoc "Polaris Music Server");

      package = mkPackageOption pkgs "polaris" { };

      user = mkOption {
        type = types.str;
        default = "polaris";
        description = lib.mdDoc "User account under which Polaris runs.";
      };

      group = mkOption {
        type = types.str;
        default = "polaris";
        description = lib.mdDoc "Group under which Polaris is run.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc "Polaris' auxiliary groups.";
        example = literalExpression ''["media" "music"]'';
      };

      port = mkOption {
        type = types.port;
        default = 5050;
        description = lib.mdDoc ''
          The port which the Polaris REST api and web UI should listen to.
          Note: polaris is hardcoded to listen to the hostname "0.0.0.0".
        '';
      };

      settings = mkOption {
        type = settingsFormat.type;
        default = {};
        description = lib.mdDoc ''
          Contents for the TOML Polaris config, applied each start.
          Although poorly documented, an example may be found here:
          [test-config.toml](https://github.com/agersant/polaris/blob/374d0ca56fc0a466d797a4b252e2078607476797/test-data/config.toml)
        '';
        example = literalExpression ''
          {
            settings.reindex_every_n_seconds = 7*24*60*60; # weekly, default is 1800
            settings.album_art_pattern =
              "(cover|front|folder)\.(jpeg|jpg|png|bmp|gif)";
            mount_dirs = [
              {
                name = "NAS";
                source = "/mnt/nas/music";
              }
              {
                name = "Local";
                source = "/home/my_user/Music";
              }
            ];
          }
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open the configured port in the firewall.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.polaris = {
      description = "Polaris Music Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = rec {
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
        SupplementaryGroups = cfg.extraGroups;
        StateDirectory = "polaris";
        CacheDirectory = "polaris";
        ExecStart = escapeShellArgs ([
          "${cfg.package}/bin/polaris"
          "--foreground"
          "--port" cfg.port
          "--database" "/var/lib/${StateDirectory}/db.sqlite"
          "--cache" "/var/cache/${CacheDirectory}"
        ] ++ optionals (cfg.settings != {}) [
          "--config" (settingsFormat.generate "polaris-config.toml" cfg.settings)
        ]);
        Restart = "on-failure";

        # Security options:

        #NoNewPrivileges = true; # implied by DynamicUser
        #RemoveIPC = true; # implied by DynamicUser

        AmbientCapabilities = "";
        CapabilityBoundingSet = "";

        DeviceAllow = "";

        LockPersonality = true;

        #PrivateTmp = true; # implied by DynamicUser
        PrivateDevices = true;
        PrivateUsers = true;

        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;

        RestrictNamespaces = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictRealtime = true;
        #RestrictSUIDSGID = true; # implied by DynamicUser

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation" "~@debug" "~@keyring" "~@memlock" "~@obsolete" "~@privileged" "~@setuid"
        ];
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

  };

  meta.maintainers = with maintainers; [ pbsds ];
}
