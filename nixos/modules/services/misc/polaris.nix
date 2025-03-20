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
          [CONFIGURATION.md](https://github.com/agersant/polaris/blob/5fe45aa059358677088bfaa4db90d16f3d09f37b/docs/CONFIGURATION.md#format)
          [test-config.toml](https://github.com/agersant/polaris/blob/5fe45aa059358677088bfaa4db90d16f3d09f37b/test-data/config.toml)

          We *merge* this config into `/var/lib/polaris/config.toml`
          using the `*` operator in `jq`. This means toplevel attributes
          and objects get properly merged, but `mount_dirs` and `users`
          will be overwritten.
        '';
        example = lib.literalExpression ''
          {
            reindex_every_n_seconds = 7*24*60*60; # weekly, default is 1800
            album_art_pattern = "(cover|front|folder)\.(jpeg|jpg|png|bmp|gif)";
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
        WorkingDirectory = "%S/${StateDirectory}";
        # This method of merging configs is "recursive" according to the jq manual, but
        # that only goes for objects, not for arrays.
        # This means that [[mount_dirs]] and [[users]] will be REPLACED
        ExecStartPre = lib.mkIf (cfg.settings != { }) (
          lib.escapeShellArgs [
            (pkgs.writeShellScript "update-polaris-config.sh" ''
              declare target_fname="$1"
              declare source_fname="$2"
              if [[ ! -s "$target_fname" ]]; then
                mkdir -p "$(dirname "$target_fname")"
                cp "$source_fname" "$target_fname"
                chmod +w "$target_fname"
              else
                ${pkgs.yq}/bin/tomlq --in-place --toml-output '. * $source' "$target_fname" --argjson source "$(${pkgs.yq}/bin/tomlq . "$source_fname" -c)"
              fi
            '')
            "%S/${StateDirectory}/config.toml"
            (settingsFormat.generate "polaris-config.toml" cfg.settings)
          ]
        );
        ExecStart = lib.escapeShellArgs ([
          "${cfg.package}/bin/polaris"
          "--foreground"
          "--port"
          cfg.port
          "--database"
          "%S/${StateDirectory}/db.sqlite"
          "--data"
          "%S/${StateDirectory}/data"
          "--cache"
          "%C/${CacheDirectory}"
          "--config"
          "%S/${StateDirectory}/config.toml"
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
