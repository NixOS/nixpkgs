{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.datadog-agent;

  ddConf = {
    dd_url              = "https://app.datadoghq.com";
    skip_ssl_validation = false;
    confd_path          = "/etc/datadog-agent/conf.d";
    additional_checksd  = "/etc/datadog-agent/checks.d";
    use_dogstatsd       = true;
  }
  // optionalAttrs (cfg.logLevel != null) { log_level = cfg.logLevel; }
  // optionalAttrs (cfg.hostname != null) { inherit (cfg) hostname; }
  // optionalAttrs (cfg.tags != null ) { tags = concatStringsSep ", " cfg.tags; }
  // optionalAttrs (cfg.enableLiveProcessCollection) { process_config = { enabled = "true"; }; }
  // optionalAttrs (cfg.enableTraceAgent) { apm_config = { enabled = true; }; }
  // cfg.extraConfig;

  # Generate Datadog configuration files for each configured checks.
  # This works because check configurations have predictable paths,
  # and because JSON is a valid subset of YAML.
  makeCheckConfigs = entries: mapAttrs' (name: conf: {
    name = "datadog-agent/conf.d/${name}.d/conf.yaml";
    value.source = pkgs.writeText "${name}-check-conf.yaml" (builtins.toJSON conf);
  }) entries;

  defaultChecks = {
    disk = cfg.diskCheck;
    network = cfg.networkCheck;
  };

  # Assemble all check configurations and the top-level agent
  # configuration.
  etcfiles = with pkgs; with builtins;
  { "datadog-agent/datadog.yaml" = {
      source = writeText "datadog.yaml" (toJSON ddConf);
    };
  } // makeCheckConfigs (cfg.checks // defaultChecks);

  # Apply the configured extraIntegrations to the provided agent
  # package. See the documentation of `dd-agent/integrations-core.nix`
  # for detailed information on this.
  datadogPkg = cfg.package.override {
    pythonPackages = pkgs.datadog-integrations-core cfg.extraIntegrations;
  };
in {
  options.services.datadog-agent = {
    enable = mkOption {
      description = ''
        Whether to enable the datadog-agent v6 monitoring service
      '';
      default = false;
      type = types.bool;
    };

    package = mkOption {
      default = pkgs.datadog-agent;
      defaultText = "pkgs.datadog-agent";
      description = ''
        Which DataDog v6 agent package to use. Note that the provided
        package is expected to have an overridable `pythonPackages`-attribute
        which configures the Python environment with the Datadog
        checks.
      '';
      type = types.package;
    };

    apiKeyFile = mkOption {
      description = ''
        Path to a file containing the Datadog API key to associate the
        agent with your account.
      '';
      example = "/run/keys/datadog_api_key";
      type = types.path;
    };

    tags = mkOption {
      description = "The tags to mark this Datadog agent";
      example = [ "test" "service" ];
      default = null;
      type = types.nullOr (types.listOf types.str);
    };

    hostname = mkOption {
      description = "The hostname to show in the Datadog dashboard (optional)";
      default = null;
      example = "mymachine.mydomain";
      type = types.nullOr types.str;
    };

    logLevel = mkOption {
      description = "Logging verbosity.";
      default = null;
      type = types.nullOr (types.enum ["DEBUG" "INFO" "WARN" "ERROR"]);
    };

    extraIntegrations = mkOption {
      default = {};
      type    = types.attrs;

      description = ''
        Extra integrations from the Datadog core-integrations
        repository that should be built and included.

        By default the included integrations are disk, mongo, network,
        nginx and postgres.

        To include additional integrations the name of the derivation
        and a function to filter its dependencies from the Python
        package set must be provided.
      '';

      example = {
        ntp = (pythonPackages: [ pythonPackages.ntplib ]);
      };
    };

    extraConfig = mkOption {
      default = {};
      type = types.attrs;
      description = ''
        Extra configuration options that will be merged into the
        main config file <filename>datadog.yaml</filename>.
      '';
     };

    enableLiveProcessCollection = mkOption {
      description = ''
        Whether to enable the live process collection agent.
      '';
      default = false;
      type = types.bool;
    };

    enableTraceAgent = mkOption {
      description = ''
        Whether to enable the trace agent.
      '';
      default = false;
      type = types.bool;
    };

    checks = mkOption {
      description = ''
        Configuration for all Datadog checks. Keys of this attribute
        set will be used as the name of the check to create the
        appropriate configuration in `conf.d/$check.d/conf.yaml`.

        The configuration is converted into JSON from the plain Nix
        language configuration, meaning that you should write
        configuration adhering to Datadog's documentation - but in Nix
        language.

        Refer to the implementation of this module (specifically the
        definition of `defaultChecks`) for an example.

        Note: The 'disk' and 'network' check are configured in
        separate options because they exist by default. Attempting to
        override their configuration here will have no effect.
      '';

      example = {
        http_check = {
          init_config = null; # sic!
          instances = [
            {
              name = "some-service";
              url = "http://localhost:1337/healthz";
              tags = [ "some-service" ];
            }
          ];
        };
      };

      default = {};

      # sic! The structure of the values is up to the check, so we can
      # not usefully constrain the type further.
      type = with types; attrsOf attrs;
    };

    diskCheck = mkOption {
      description = "Disk check config";
      type = types.attrs;
      default = {
        init_config = {};
        instances = [ { use_mount = "false"; } ];
      };
    };

    networkCheck = mkOption {
      description = "Network check config";
      type = types.attrs;
      default = {
        init_config = {};
        # Network check only supports one configured instance
        instances = [ { collect_connection_state = false;
          excluded_interfaces = [ "lo" "lo0" ]; } ];
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ datadogPkg pkgs.sysstat pkgs.procps pkgs.iproute ];

    users.users.datadog = {
      description = "Datadog Agent User";
      uid = config.ids.uids.datadog;
      group = "datadog";
      home = "/var/log/datadog/";
      createHome = true;
    };

    users.groups.datadog.gid = config.ids.gids.datadog;

    systemd.services = let
      makeService = attrs: recursiveUpdate {
        path = [ datadogPkg pkgs.python pkgs.sysstat pkgs.procps pkgs.iproute ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "datadog";
          Group = "datadog";
          Restart = "always";
          RestartSec = 2;
        };
        restartTriggers = [ datadogPkg ] ++ attrNames etcfiles;
      } attrs;
    in {
      datadog-agent = makeService {
        description = "Datadog agent monitor";
        preStart = ''
          chown -R datadog: /etc/datadog-agent
          rm -f /etc/datadog-agent/auth_token
        '';
        script = ''
          export DD_API_KEY=$(head -n 1 ${cfg.apiKeyFile})
          exec ${datadogPkg}/bin/agent run -c /etc/datadog-agent/datadog.yaml
        '';
        serviceConfig.PermissionsStartOnly = true;
      };

      dd-jmxfetch = lib.mkIf (lib.hasAttr "jmx" cfg.checks) (makeService {
        description = "Datadog JMX Fetcher";
        path = [ datadogPkg pkgs.python pkgs.sysstat pkgs.procps pkgs.jdk ];
        serviceConfig.ExecStart = "${datadogPkg}/bin/dd-jmxfetch";
      });

      datadog-process-agent = lib.mkIf cfg.enableLiveProcessCollection (makeService {
        description = "Datadog Live Process Agent";
        path = [ ];
        script = ''
          export DD_API_KEY=$(head -n 1 ${cfg.apiKeyFile})
          ${pkgs.datadog-process-agent}/bin/agent --config /etc/datadog-agent/datadog.yaml
        '';
      });

      datadog-trace-agent = lib.mkIf cfg.enableTraceAgent (makeService {
        description = "Datadog Trace Agent";
        path = [ ];
        script = ''
          export DD_API_KEY=$(head -n 1 ${cfg.apiKeyFile})
          ${datadogPkg}/bin/trace-agent -config /etc/datadog-agent/datadog.yaml
        '';
      });

    };

    environment.etc = etcfiles;
  };
}
