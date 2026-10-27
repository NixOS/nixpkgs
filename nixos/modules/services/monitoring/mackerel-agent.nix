{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mackerel-agent;
  settingsFmt = pkgs.formats.toml { };
in
{
  options.services.mackerel-agent = {
    enable = lib.mkEnableOption "mackerel.io agent";

    # the upstream package runs as root, but doesn't seem to be strictly
    # necessary for basic functionality
    runAsRoot = lib.mkEnableOption "running as root";

    autoRetirement = lib.mkEnableOption ''
      retiring the host upon OS shutdown
    '';

    apiKeyFile = lib.mkOption {
      type = lib.types.path;
      example = "/run/keys/mackerel-api-key";
      description = ''
        Path to file containing the Mackerel API key. The file should contain a
        single line of the following form:

        `apikey = "EXAMPLE_API_KEY"`
      '';
    };

    settings = lib.mkOption {
      description = ''
        Options for mackerel-agent.conf.

        Documentation:
        <https://mackerel.io/docs/entry/spec/agent>
      '';

      default = { };
      example = {
        verbose = false;
        silent = false;
      };

      type = lib.types.submodule {
        freeformType = settingsFmt.type;

        options.host_status = {
          on_start = lib.mkOption {
            type = lib.types.enum [
              "working"
              "standby"
              "maintenance"
              "poweroff"
            ];
            description = "Host status after agent startup.";
            default = "working";
          };
          on_stop = lib.mkOption {
            type = lib.types.enum [
              "working"
              "standby"
              "maintenance"
              "poweroff"
            ];
            description = "Host status after agent shutdown.";
            default = "poweroff";
          };
        };

        options.diagnostic = lib.mkEnableOption "collecting memory usage for the agent itself";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mackerel-agent ];

    environment.etc = {
      "mackerel-agent/mackerel-agent.conf".source =
        settingsFmt.generate "mackerel-agent.conf" cfg.settings;
      "mackerel-agent/conf.d/api-key.conf".source = cfg.apiKeyFile;
    };

    services.mackerel-agent.settings = {
      root = lib.mkDefault "/var/lib/mackerel-agent";
      pidfile = lib.mkDefault "/run/mackerel-agent/mackerel-agent.pid";

      # conf.d stores the symlink to cfg.apiKeyFile
      include = lib.mkDefault "/etc/mackerel-agent/conf.d/*.conf";
    };

    # upstream service file in https://github.com/mackerelio/mackerel-agent/blob/master/packaging/rpm/src/mackerel-agent.service
    systemd.services.mackerel-agent = {
      description = "mackerel.io agent";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "nss-lookup.target"
      ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        MACKEREL_PLUGIN_WORKDIR = lib.mkDefault "%C/mackerel-agent";
      };
      serviceConfig = {
        DynamicUser = !cfg.runAsRoot;
        PrivateTmp = lib.mkDefault true;
        CacheDirectory = "mackerel-agent";
        ConfigurationDirectory = "mackerel-agent";
        RuntimeDirectory = "mackerel-agent";
        StateDirectory = "mackerel-agent";
        ExecStart = "${pkgs.mackerel-agent}/bin/mackerel-agent supervise";
        ExecStopPost = lib.mkIf cfg.autoRetirement "${pkgs.mackerel-agent}/bin/mackerel-agent retire -force";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LimitNOFILE = lib.mkDefault 65536;
        LimitNPROC = lib.mkDefault 65536;
      };
      restartTriggers = [
        config.environment.etc."mackerel-agent/mackerel-agent.conf".source
      ];
    };
  };
}
