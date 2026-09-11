{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.libreqos;
  toml = pkgs.formats.toml { };

  configFile = toml.generate "lqos.conf" cfg.settings;
in
{
  meta = {
    maintainers = [ lib.maintainers.stepbrobd ];
    teams = [ lib.teams.ngi ];
  };

  options.services.libreqos = {
    enable = lib.mkEnableOption "LibreQoS, a traffic shaping and quality-of-experience management platform";

    package = lib.mkPackageOption pkgs "libreqos" { };

    openFirewall = lib.mkEnableOption ''
      Whether to open the web UI port in the firewall.
      See {option}`services.libreqos.settings.webserver_listen`.
    '';

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = toml.type;
      };
      default = { };
      example = lib.literalExpression ''
        {
          bridge = {
            use_xdp_bridge = false;
            to_internet = "eth0";
            to_network = "eth1";
          };
          queues = {
            uplink_bandwidth_mbps = 1000;
            downlink_bandwidth_mbps = 1000;
          };
        }
      '';
      description = ''
        Rendered to {file}`/etc/lqos.conf`.

        See [example configuration](https://github.com/LibreQoE/LibreQoS/blob/main/src/lqos.example) for available options.
        Exactly one of the `bridge` or `single_interface` sections must be set.

        The shaping data files {file}`network.json` and {file}`ShapedDevices.csv` in {file}`/var/lib/libreqos`
        are mutable (optional) runtime data, normally managed through the web UI or a CRM integration.
        Empty files are created if they are missing. To manage them declaratively instead, symlink them into place:

        ```nix
        systemd.tmpfiles.rules = [
          "L+ /var/lib/libreqos/network.json - - - - ''${./network.json}"
          "L+ /var/lib/libreqos/ShapedDevices.csv - - - - ''${./ShapedDevices.csv}"
        ];
        ```
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.settings ? bridge) != (cfg.settings ? single_interface);
        message = "services.libreqos.settings must contain exactly one of the `bridge` or `single_interface` sections";
      }
      {
        assertion = cfg.settings ? node_id;
        message = "services.libreqos.settings.node_id must be set, either directly or through networking.hostId which is used as its default";
      }
      {
        assertion =
          lib.isString cfg.settings.webserver_listen
          && (
            let
              port = builtins.tryEval (lib.toInt (lib.last (lib.splitString ":" cfg.settings.webserver_listen)));
            in
            port.success && port.value >= 0 && port.value <= 65535
          );
        message = "services.libreqos.settings.webserver_listen must end with an integer port in the range 0-65535 after splitting on `:`";
      }
    ];

    services.libreqos.settings = {
      version = lib.mkDefault "1.5";
      lqos_directory = "/var/lib/libreqos";
      node_id = lib.mkIf (config.networking.hostId != null) (lib.mkDefault config.networking.hostId);
      node_name = lib.mkDefault config.networking.fqdnOrHostName;
      webserver_listen = lib.mkDefault ":::9123";
      packet_capture_time = lib.mkDefault 10;
      queue_check_period_ms = lib.mkDefault 1000;
      tuning = {
        stop_irq_balance = lib.mkDefault true;
        netdev_budget_usecs = lib.mkDefault 8000;
        netdev_budget_packets = lib.mkDefault 300;
        rx_usecs = lib.mkDefault 8;
        tx_usecs = lib.mkDefault 8;
        disable_rxvlan = lib.mkDefault true;
        disable_txvlan = lib.mkDefault true;
        disable_offload = lib.mkDefault [
          "gso"
          "tso"
          "lro"
          "sg"
          "gro"
        ];
      };
      queues = {
        default_sqm = lib.mkDefault "cake diffserv4";
        uplink_bandwidth_mbps = lib.mkDefault 1000;
        downlink_bandwidth_mbps = lib.mkDefault 1000;
        generated_pn_download_mbps = lib.mkDefault 1000;
        generated_pn_upload_mbps = lib.mkDefault 1000;
      };
      long_term_stats = {
        gather_stats = lib.mkDefault false;
        collation_period_seconds = lib.mkDefault 10;
      };
      ip_ranges = {
        ignore_subnets = lib.mkDefault [ ];
        allow_subnets = lib.mkDefault [
          "172.16.0.0/12"
          "10.0.0.0/8"
          "100.64.0.0/10"
          "192.168.0.0/16"
        ];
      };
    };

    environment.etc."lqos.conf".source = configFile;

    # upstream have config migration that rewrites /etc/lqos.conf in place unless matching stamp file exists
    environment.etc."lqos.conf.topology_compile_mode_migrated".text = "skipped\n";
    environment.etc."lqos.conf.treeguard_cpu_mode_migrated".text = "cpu_aware\n";
    environment.etc."lqos.conf.treeguard_links_virtualization_migrated".text = "disabled\n";
    environment.etc."lqos.conf.uisp_capacity_defaults_migrated".text = "1.0\n";

    environment.systemPackages = [ cfg.package ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      (lib.toInt (lib.last (lib.splitString ":" cfg.settings.webserver_listen)))
    ];

    systemd.services.lqosd = {
      description = "LibreQoS traffic shaping daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      restartTriggers = [ configFile ];
      preStart = ''
        # prune links installed by previous package versions
        find "$STATE_DIRECTORY" -maxdepth 2 -lname '/nix/store/*/lib/libreqos*' -delete

        # lqosd writes into bin/ (dashboard themes, etc.)
        shopt -s extglob
        ln -sfn -t "$STATE_DIRECTORY" ${cfg.package}/lib/libreqos/!(bin|qoo_profiles.json)
        mkdir -p "$STATE_DIRECTORY/bin"
        ln -sfn -t "$STATE_DIRECTORY/bin" ${cfg.package}/lib/libreqos/bin/*

        # seed runtime data
        # LibreQoS.py opens network.json and ShapedDevices.csv unguarded (both must exist)
        [ -e "$STATE_DIRECTORY/qoo_profiles.json" ] || install -m 644 ${cfg.package}/lib/libreqos/qoo_profiles.json "$STATE_DIRECTORY/"
        [ -e "$STATE_DIRECTORY/network.json" ] || printf '{}' > "$STATE_DIRECTORY/network.json"
        [ -e "$STATE_DIRECTORY/ShapedDevices.csv" ] || head -n 1 ${cfg.package}/lib/libreqos/ShapedDevices.example.csv > "$STATE_DIRECTORY/ShapedDevices.csv"
      '';
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "lqosd";
        Restart = "always";
        StateDirectory = "libreqos";
        # lqosd, LibreQoS.py, and web UI resolve everything relative to lqos_directory
        WorkingDirectory = "/var/lib/libreqos";
      };
    };

    # web UI scheduler controls invoke `systemctl restart lqos_scheduler`
    systemd.services.lqos_scheduler = {
      description = "LibreQoS queue refresh scheduler";
      requires = [ "lqosd.service" ];
      after = [ "lqosd.service" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "lqos_scheduler";
        Restart = "always";
        StateDirectory = "libreqos";
        # LibreQoS.py writes state relative to the working directory
        WorkingDirectory = "/var/lib/libreqos";
      };
    };
  };
}
