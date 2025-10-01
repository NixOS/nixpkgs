{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkPackageOption
    mkOption
    types
    escapeShellArgs
    concatStringsSep
    ;
  inherit (lib.generators) mkKeyValueDefault mkValueStringDefault;
  inherit (lib.attrsets) recursiveUpdate;

  cfg = config.services.prometheus.exporters.mktxp;

  settingsFormat = pkgs.formats.ini {
    mkKeyValue = mkKeyValueDefault rec {
      mkValueString =
        v:
        if builtins.isNull v then
          "None"
        else if builtins.isBool v then
          (if v then "True" else "False")
        else if builtins.isList v then
          # Join lists as "a, b, c"
          concatStringsSep ", " (map mkValueString v)
        else
          mkValueStringDefault { } v;
    } "=";
  };

  sectionType = settingsFormat.lib.types.atom; # attrsOf INI atom

  configFile =
    if cfg.configFile != null then
      cfg.configFile
    else
      let
        mktxpSettings = {
          MKTXP.listen = "${cfg.listenAddress}:${toString cfg.port}";
        };
        merged = recursiveUpdate mktxpSettings cfg.settings;
      in
      settingsFormat.generate "mktxp.conf" merged;
in
{
  port = 49090;

  extraOpts = {
    package = mkPackageOption pkgs "mktxp" { };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        The path to the mktxp configuration ini file. For more info see
        https://github.com/akpw/mktxp

        Note that setting this option is mutually exclusive with setting
        the `settings` option.
      '';
    };

    settings =
      let
        mkMktxpSection = types.submodule {
          freeformType = sectionType;
          options = {
            socket_timeout = mkOption {
              type = types.int;
              default = 5;
              description = "";
            };

            initial_delay_on_failure = mkOption {
              type = types.int;
              default = 120;
              description = "";
            };

            max_delay_on_failure = mkOption {
              type = types.int;
              default = 900;
              description = "";
            };

            delay_inc_div = mkOption {
              type = types.int;
              default = 5;
              description = "";
            };

            bandwidth = mkOption {
              type = types.bool;
              default = false;
              description = "Turns metrics bandwidth metrics collection on / off";
            };

            bandwidth_test_dns_server = mkOption {
              type = types.str;
              default = "8.8.8.8";
              description = "The DNS server to be used for the bandwidth test connectivity check";
            };

            bandwidth_test_interval = mkOption {
              type = types.int;
              default = 600;
              description = "Interval for collecting bandwidth metrics";
            };

            minimal_collect_interval = mkOption {
              type = types.int;
              default = 5;
              description = "Minimal metric collection interval";
            };

            verbose_mode = mkOption {
              type = types.bool;
              default = false;
              description = "Set it on for troubleshooting";
            };

            fetch_routers_in_parallel = mkOption {
              type = types.bool;
              default = false;
              description = "Fetch metrics from multiple routers in parallel / sequentially";
            };

            max_worker_threads = mkOption {
              type = types.int;
              default = 5;
              description = "Max number of worker threads that can fetch routers (parallel fetch only)";
            };

            max_scrape_duration = mkOption {
              type = types.int;
              default = 30;
              description = "Max duration of individual routers' metrics collection (parallel fetch only)";
            };

            total_max_scrape_duration = mkOption {
              type = types.int;
              default = 90;
              description = "Max overall duration of all metrics collection (parallel fetch only)";
            };

            persistent_router_connection_pool = mkOption {
              type = types.bool;
              default = true;
              description = "Use a persistent router connections pool between scrapes";
            };

            persistent_dhcp_cache = mkOption {
              type = types.bool;
              default = true;
              description = "Persist DHCP cache between metric collections";
            };

            compact_default_conf_values = mkOption {
              type = types.bool;
              default = false;
              description = "Compact mktxp.conf, so only specific values are kept on the individual routers' level";
            };

            prometheus_headers_deduplication = mkOption {
              type = types.bool;
              default = false;
              description = "Deduplicate Prometheus HELP / TYPE headers in the metrics output";
            };
          };
        };

        mkDeviceSection = types.submodule {
          freeformType = sectionType;
          options = {
            enabled = mkOption {
              type = types.bool;
              default = false;
              description = "Turns metrics collection for this RouterOS device on / off";
            };

            hostname = mkOption {
              type = types.str;
              default = "localhost";
              description = "RouterOS IP address";
            };

            port = mkOption {
              type = types.port;
              default = 8728;
              description = "RouterOS IP Port";
            };

            username = mkOption {
              type = types.str;
              default = "username";
              description = "RouterOS user, needs to have 'read' and 'api' permissions";
            };

            password = mkOption {
              type = types.str;
              default = "password";
              description = "RouterOS user plaintext password";
            };

            credentials_file = mkOption {
              type = types.nullOr types.path;
              default = null;
              # NOTE: mktxp uses "" to indicate no credentials_file
              apply = v: if builtins.isNull v then "" else toString v;
              description = "To use an external file in YAML format for both username and password, specify the path here";
            };

            # NOTE: mktxp uses None here to indicate emptiness
            custom_labels = mkOption {
              type = types.nullOr (types.listOf types.str);
              default = null;
              description = "Custom labels to be injected to all device metrics, strings of `key:value` or `key=value` pairs";
            };

            use_ssl = mkOption {
              type = types.bool;
              default = false;
              description = "Enables connection via API-SSL servis";
            };

            no_ssl_certificate = mkOption {
              type = types.bool;
              default = false;
              description = "Enables API_SSL connect without router SSL certificate";
            };

            ssl_certificate_verify = mkOption {
              type = types.bool;
              default = false;
              description = "Turns SSL certificate verification on / off";
            };

            ssl_ca_file = mkOption {
              type = types.nullOr types.path;
              default = null;
              # NOTE: mktxp uses "" to indicate no ssl_ca_file
              apply = v: if builtins.isNull v then "" else toString v;

              description = "path to the certificate authority file to validate against, null to use system store";
            };

            plaintext_login = mkOption {
              type = types.bool;
              default = true;
              description = "For legacy RouterOS versions below 6.43 use false";
            };

            health = mkOption {
              type = types.bool;
              default = true;
              description = "Collect System Health metrics";
            };

            installed_packages = mkOption {
              type = types.bool;
              default = true;
              description = "Collect installed packages";
            };

            dhcp = mkOption {
              type = types.bool;
              default = true;
              description = "Collect DHCP general metrics";
            };

            dhcp_lease = mkOption {
              type = types.bool;
              default = true;
              description = "Collect DHCP lease metrics";
            };

            connections = mkOption {
              type = types.bool;
              default = true;
              description = "Collect IP connections metrics";
            };

            connection_stats = mkOption {
              type = types.bool;
              default = false;
              description = "Collect open IP connections metrics";
            };

            interface = mkOption {
              type = types.bool;
              default = true;
              description = "Collect interfaces traffic metrics";
            };

            route = mkOption {
              type = types.bool;
              default = true;
              description = "Collect IPv4 Routes metrics";
            };

            pool = mkOption {
              type = types.bool;
              default = true;
              description = "Collect IPv4 Pool metrics";
            };

            firewall = mkOption {
              type = types.bool;
              default = true;
              description = "Collect IPv4 Firewall rules traffic metrics";
            };

            neighbor = mkOption {
              type = types.bool;
              default = true;
              description = "Collect IPv4 Reachable Neighbors";
            };

            address_list = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "Firewall Address List metrics, a list of names";
            };

            dns = mkOption {
              type = types.bool;
              default = false;
              description = "Collect DNS stats";
            };

            ipv6_route = mkOption {
              type = types.bool;
              default = false;
              description = "Collect IPv6 Routes metrics";
            };

            ipv6_pool = mkOption {
              type = types.bool;
              default = false;
              description = "Collect IPv6 Pool metrics";
            };

            ipv6_firewall = mkOption {
              type = types.bool;
              default = false;
              description = "Collect IPv6 Firewall rules traffic metrics";
            };

            ipv6_neighbor = mkOption {
              type = types.bool;
              default = false;
              description = "Collect IPv6 Reachable Neighbors";
            };

            ipv6_address_list = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "IPv6 Firewall Address List metrics, a list of names";
            };

            poe = mkOption {
              type = types.bool;
              default = true;
              description = "Collect POE metrics";
            };

            monitor = mkOption {
              type = types.bool;
              default = true;
              description = "Collect interface monitor metrics";
            };

            netwatch = mkOption {
              type = types.bool;
              default = true;
              description = "Collect netwatch metrics";
            };

            public_ip = mkOption {
              type = types.bool;
              default = true;
              description = "Collect public IP metrics";
            };

            wireless = mkOption {
              type = types.bool;
              default = true;
              description = "Collect WLAN general metrics";
            };

            wireless_clients = mkOption {
              type = types.bool;
              default = true;
              description = "Collect WLAN clients metrics";
            };

            capsman = mkOption {
              type = types.bool;
              default = true;
              description = "Collect CAPsMAN general metrics";
            };

            capsman_clients = mkOption {
              type = types.bool;
              default = true;
              description = "Collect CAPsMAN clients metrics";
            };

            w60g = mkOption {
              type = types.bool;
              default = false;
              description = "Collect W60G metrics";
            };

            eoip = mkOption {
              type = types.bool;
              default = false;
              description = "Collect EoIP status metrics";
            };

            gre = mkOption {
              type = types.bool;
              default = false;
              description = "Collect GRE status metrics";
            };

            ipip = mkOption {
              type = types.bool;
              default = false;
              description = "Collect IPIP status metrics";
            };

            lte = mkOption {
              type = types.bool;
              default = false;
              description = "Collect LTE signal and status metrics (requires additional 'test' permission policy on RouterOS v6)";
            };

            ipsec = mkOption {
              type = types.bool;
              default = false;
              description = "Collect IPSec active peer metrics";
            };

            switch_port = mkOption {
              type = types.bool;
              default = false;
              description = "Collect Switch Port metrics";
            };

            kid_control_assigned = mkOption {
              type = types.bool;
              default = false;
              description = "Allow Kid Control metrics for connected devices with assigned users";
            };

            kid_control_dynamic = mkOption {
              type = types.bool;
              default = false;
              description = "Allow Kid Control metrics for all connected devices, including those without assigned user";
            };

            user = mkOption {
              type = types.bool;
              default = true;
              description = "Collect Active Users metrics";
            };

            queue = mkOption {
              type = types.bool;
              default = true;
              description = "Collect Queues metrics";
            };

            bfd = mkOption {
              type = types.bool;
              default = false;
              description = "Collect BFD sessions metrics";
            };

            bgp = mkOption {
              type = types.bool;
              default = false;
              description = "Collect BGP sessions metrics";
            };

            routing_stats = mkOption {
              type = types.bool;
              default = false;
              description = "Collect Routing process stats";
            };

            certificate = mkOption {
              type = types.bool;
              default = false;
              description = "Collect Certificates metrics";
            };

            container = mkOption {
              type = types.bool;
              default = false;
              description = "Collect Containers metrics";
            };

            remote_dhcp_entry = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "An MKTXP entry to provide for remote DHCP info / resolution";
            };

            remote_capsman_entry = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "An MKTXP entry to provide for remote capsman info";
            };

            use_comments_over_names = mkOption {
              type = types.bool;
              default = true;
              description = "when available, forces using comments over the interfaces names";
            };

            check_for_updates = mkOption {
              type = types.bool;
              default = false;
              description = "Check for available ROS updates";
            };
          };
        };
      in
      mkOption {
        type = types.submodule {
          freeformType = types.attrsOf mkDeviceSection;
          options = {
            # [MKTXP]
            MKTXP = mkOption {
              type = mkMktxpSection;
              default = { };
              description = "Global MKTXP settings (rendered as the [MKTXP] section).";
            };

            # [default]
            default = mkOption {
              type = mkDeviceSection;
              default = { };
              description = "Defaults for all devices (rendered as the [default] section).";
            };

            # general [<device>] included in freeformType
          };
        };
        default = { };
        description = ''
          Structured mktxp configuration. For more info see
          https://github.com/akpw/mktxp

          Note that setting this option is mutually exclusive with setting
          the `configFile` option.
        '';
      };

  };

  serviceOpts = {
    # NOTE: mktxp unfortunately does not support passing a custom
    # configuration file or a custom config directory, it always reads what is
    # present in $HOME/mktxp/mktxp.conf, so we populate a dynamics user's
    # home directory with a symlink to the pure store configuration file.
    environment.HOME = "/var/run/mktxp/";
    preStart = ''
      mkdir -p "$HOME/mktxp"
      ln -sf "${configFile}" "$HOME/mktxp/mktxp.conf"
    '';
    serviceConfig = {
      DynamicUser = true;
      RuntimeDirectory = "mktxp";
      ExecStart = "${getExe cfg.package} export ${escapeShellArgs cfg.extraFlags}";
    };
  };
}
