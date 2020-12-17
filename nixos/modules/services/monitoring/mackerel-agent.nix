{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mackerel-agent;
  settingsFmt = pkgs.formats.toml {};
in {
  options.services.mackerel-agent = {
    enable = mkEnableOption "mackerel.io agent";

    # the upstream package runs as root, but doesn't seem to be strictly
    # necessary for basic functionality
    runAsRoot = mkEnableOption "Whether to run as root.";

    autoRetirement = mkEnableOption ''
      Whether to automatically retire the host upon OS shutdown.
    '';

    apiKeyFile = mkOption {
      type = types.path;
      default = "";
      example = "/run/keys/mackerel-api-key";
      description = ''
        Path to file containing the Mackerel API key. The file should contain a
        single line of the following form:

        <literallayout>apikey = "EXAMPLE_API_KEY"</literallayout>
      '';
    };

    settings = mkOption {
      description = ''
        Options for mackerel-agent.conf.

        Documentation:
        <link xlink:href="https://mackerel.io/docs/entry/spec/agent"/>
      '';

      default = {};
      example = {
        verbose = false;
        silent = false;
      };

      type = types.submodule {
        freeformType = settingsFmt.type;

        options.host_status = {
          on_start = mkOption {
            type = types.enum [ "working" "standby" "maintenance" "poweroff" ];
            description = "Host status after agent startup.";
            default = "working";
          };
          on_stop = mkOption {
            type = types.enum [ "working" "standby" "maintenance" "poweroff" ];
            description = "Host status after agent shutdown.";
            default = "poweroff";
          };
        };

        options.diagnostic =
          mkEnableOption "Collect memory usage for the agent itself";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mackerel-agent ];

    environment.etc = {
      "mackerel-agent/mackerel-agent.conf".source =
        settingsFmt.generate "mackerel-agent.conf" cfg.settings;
      "mackerel-agent/conf.d/api-key.conf".source = cfg.apiKeyFile;
    };

    services.mackerel-agent.settings = {
      root = mkDefault "/var/lib/mackerel-agent";
      pidfile = mkDefault "/run/mackerel-agent/mackerel-agent.pid";

      # conf.d stores the symlink to cfg.apiKeyFile
      include = mkDefault "/etc/mackerel-agent/conf.d/*.conf";
    };

    # upstream service file in https://git.io/JUt4Q
    systemd.services.mackerel-agent = {
      description = "mackerel.io agent";
      after = [ "network-online.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        MACKEREL_PLUGIN_WORKDIR = mkDefault "%C/mackerel-agent";
      };
      serviceConfig = {
        DynamicUser = !cfg.runAsRoot;
        PrivateTmp = mkDefault true;
        CacheDirectory = "mackerel-agent";
        ConfigurationDirectory = "mackerel-agent";
        RuntimeDirectory = "mackerel-agent";
        StateDirectory = "mackerel-agent";
        ExecStart = "${pkgs.mackerel-agent}/bin/mackerel-agent supervise";
        ExecStopPost = mkIf cfg.autoRetirement "${pkg.mackerel-agent}/bin/mackerel-agent retire -force";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LimitNOFILE = mkDefault 65536;
        LimitNPROC = mkDefault 65536;
      };
      restartTriggers = [
        config.environment.etc."mackerel-agent/mackerel-agent.conf".source
      ];
    };
  };
}
