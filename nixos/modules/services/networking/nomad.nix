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

      package = mkOption {
        type = types.package;
        default = pkgs.nomad;
        defaultText = "pkgs.nomad";
        description = ''
          The package used for the Nomad agent and CLI.
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          Extra packages to add to <envar>PATH</envar> for the Nomad agent process.
        '';
        example = literalExample ''
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
        default = [];
        description = ''
          Additional settings paths used to configure nomad. These can be files or directories.
        '';
        example = literalExample ''
          [ "/etc/nomad-mutable.json" "/run/keys/nomad-with-secrets.json" "/etc/nomad/config.d" ]
        '';
      };

      settings = mkOption {
        type = format.type;
        default = {};
        description = ''
          Configuration for Nomad. See the <link xlink:href="https://www.nomadproject.io/docs/configuration">documentation</link>
          for supported values.

          Notes about <literal>data_dir</literal>:

          If <literal>data_dir</literal> is set to a value other than the
          default value of <literal>"/var/lib/nomad"</literal> it is the Nomad
          cluster manager's responsibility to make sure that this directory
          exists and has the appropriate permissions.

          Additionally, if <literal>dropPrivileges</literal> is
          <literal>true</literal> then <literal>data_dir</literal>
          <emphasis>cannot</emphasis> be customized. Setting
          <literal>dropPrivileges</literal> to <literal>true</literal> enables
          the <literal>DynamicUser</literal> feature of systemd which directly
          manages and operates on <literal>StateDirectory</literal>.
        '';
        example = literalExample ''
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
        iproute
        iptables
      ]);

      serviceConfig = mkMerge [
        {
          DynamicUser = cfg.dropPrivileges;
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          ExecStart = "${cfg.package}/bin/nomad agent -config=/etc/nomad.json" +
            concatMapStrings (path: " -config=${path}") cfg.extraSettingsPaths;
          KillMode = "process";
          KillSignal = "SIGINT";
          LimitNOFILE = 65536;
          LimitNPROC = "infinity";
          OOMScoreAdjust = -1000;
          Restart = "on-failure";
          RestartSec = 2;
          TasksMax = "infinity";
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
