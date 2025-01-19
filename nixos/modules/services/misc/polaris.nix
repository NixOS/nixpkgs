{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.polaris;
  settingsFormat = pkgs.formats.toml { };
in
{
  options = {
    services.polaris = {
      enable = lib.mkEnableOption "Polaris Music Server";

      package = lib.mkPackageOption pkgs "polaris" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "polaris";
        description = "User account under which Polaris runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "polaris";
        description = "Group under which Polaris is run.";
      };

      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Polaris' auxiliary groups.";
        example = lib.literalExpression ''["media" "music"]'';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5050;
        description = ''
          The port which the Polaris REST api and web UI should listen to.
          Note: polaris is hardcoded to listen to the hostname "0.0.0.0".
        '';
      };

      settings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        description = ''
          Contents for the TOML Polaris config, applied each start.
          Although poorly documented, an example may be found here:
          [test-config.toml](https://github.com/agersant/polaris/blob/374d0ca56fc0a466d797a4b252e2078607476797/test-data/config.toml)
        '';
        example = lib.literalExpression ''
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

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open the configured port in the firewall.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
        ExecStart = lib.escapeShellArgs (
          [
            "${cfg.package}/bin/polaris"
            "--foreground"
            "--port"
            cfg.port
            "--database"
            "/var/lib/${StateDirectory}/db.sqlite"
            "--cache"
            "/var/cache/${CacheDirectory}"
          ]
          ++ lib.optionals (cfg.settings != { }) [
            "--config"
            (settingsFormat.generate "polaris-config.toml" cfg.settings)
          ]
        );
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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictRealtime = true;
        #RestrictSUIDSGID = true; # implied by DynamicUser

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@obsolete"
          "~@privileged"
          "~@setuid"
        ];
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

  };

  meta.maintainers = with lib.maintainers; [ pbsds ];
}
