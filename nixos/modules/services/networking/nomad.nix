{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.nomad;
  format = pkgs.formats.json { };
in
{
  ##### interface
  options = {
    services.nomad = {
      enable = mkEnableOption "Nomad, a distributed, highly available, datacenter-aware scheduler";

      package = mkPackageOption pkgs "nomad" { };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          Extra packages to add to {env}`PATH` for the Nomad agent process.
        '';
        example = literalExpression ''
          with pkgs; [ cni-plugins ]
        '';
      };

      dropPrivileges = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether the nomad agent should be run as a non-root nomad user.
        '';
      };

      enableDocker = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable Docker support. Needed for Nomad's docker driver.

          Note that the docker group membership is effectively equivalent
          to being root, see https://github.com/moby/moby/issues/9976.
        '';
      };

      extraSettingsPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          Additional settings paths used to configure nomad. These can be files or directories.
        '';
        example = literalExpression ''
          [ "/etc/nomad-mutable.json" "/run/keys/nomad-with-secrets.json" "/etc/nomad/config.d" ]
        '';
      };

      extraSettingsPlugins = mkOption {
        type = types.listOf (types.either types.package types.path);
        default = [ ];
        description = ''
          Additional plugins dir used to configure nomad.
        '';
        example = literalExpression ''
          [ "<pluginDir>" pkgs.nomad-driver-nix pkgs.nomad-driver-podman  ]
        '';
      };

      credentials = mkOption {
        description = ''
          Credentials envs used to configure nomad secrets.
        '';
        type = types.attrsOf types.str;
        default = { };

        example = {
          logs_remote_write_password = "/run/keys/nomad_write_password";
        };
      };

      settings = mkOption {
        type = format.type;
        default = { };
        description = ''
          Configuration for Nomad. See the [documentation](https://www.nomadproject.io/docs/configuration)
          for supported values.

          Notes about `data_dir`:

          If `data_dir` is set to a value other than the
          default value of `"/var/lib/nomad"` it is the Nomad
          cluster manager's responsibility to make sure that this directory
          exists and has the appropriate permissions.

          Additionally, if `dropPrivileges` is
          `true` then `data_dir`
          *cannot* be customized. Setting
          `dropPrivileges` to `true` enables
          the `DynamicUser` feature of systemd which directly
          manages and operates on `StateDirectory`.
        '';
        example = literalExpression ''
          {
            # A minimal config example:
            server = {
              enabled = true;
              bootstrap_expect = 1; # for demo; no fault tolerance
            };
            client = {
              enabled = true;
            };
          }
        '';
      };
    };
  };

  ##### implementation
  config = mkIf cfg.enable {
    services.nomad.settings = {
      # Agrees with `StateDirectory = "nomad"` set below.
      data_dir = mkDefault "/var/lib/nomad";
    };

    environment = {
      etc."nomad.json".source = format.generate "nomad.json" cfg.settings;
      systemPackages = [ cfg.package ];
    };

    systemd.services.nomad = {
      description = "Nomad";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      restartTriggers = [ config.environment.etc."nomad.json".source ];

      path = cfg.extraPackages ++ (with pkgs; [
        # Client mode requires at least the following:
        coreutils
        iproute2
        iptables
      ]);

      serviceConfig = mkMerge [
        {
          DynamicUser = cfg.dropPrivileges;
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          ExecStart =
            let
              pluginsDir = pkgs.symlinkJoin
                {
                  name = "nomad-plugins";
                  paths = cfg.extraSettingsPlugins;
                };
            in
            "${cfg.package}/bin/nomad agent -config=/etc/nomad.json -plugin-dir=${pluginsDir}/bin" +
            concatMapStrings (path: " -config=${path}") cfg.extraSettingsPaths +
            concatMapStrings (key: " -config=\${CREDENTIALS_DIRECTORY}/${key}") (lib.attrNames cfg.credentials);
          KillMode = "process";
          KillSignal = "SIGINT";
          LimitNOFILE = 65536;
          LimitNPROC = "infinity";
          OOMScoreAdjust = -1000;
          Restart = "on-failure";
          RestartSec = 2;
          TasksMax = "infinity";
          LoadCredential = lib.mapAttrsToList (key: value: "${key}:${value}") cfg.credentials;
        }
        (mkIf cfg.enableDocker {
          SupplementaryGroups = "docker"; # space-separated string
        })
        (mkIf (cfg.settings.data_dir == "/var/lib/nomad") {
          StateDirectory = "nomad";
        })
      ];

      unitConfig = {
        StartLimitIntervalSec = 10;
        StartLimitBurst = 3;
      };
    };

    assertions = [
      {
        assertion = cfg.dropPrivileges -> cfg.settings.data_dir == "/var/lib/nomad";
        message = "settings.data_dir must be equal to \"/var/lib/nomad\" if dropPrivileges is true";
      }
    ];

    # Docker support requires the Docker daemon to be running.
    virtualisation.docker.enable = mkIf cfg.enableDocker true;
  };
}
