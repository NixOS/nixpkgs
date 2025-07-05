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
    concatStringsSep
    mapAttrsRecursive
    ;

  cfg = config.services.prometheus.exporters.mktxp;

  toPythonINI =
    config:
    let
      remapBoolsAndNull =
        attrs:
        mapAttrsRecursive (
          _: value:
          if value == null then
            "None"
          else if builtins.isBool value then
            (if value then "True" else "False")
          else
            value
        ) attrs;
    in
    lib.generators.toINI { } (remapBoolsAndNull config);

  configFile =
    if cfg.configFile != null then
      cfg.configFile
    else
      let
        # NOTE: Without the default configuration, mktxp tries to append it
        # itself and fails in case of a read-only config.
        defaultConfiguration = {
          MKTXP = {
            listen = "${cfg.listenAddress}:${toString cfg.port}";
          };
          default = {
            enabled = false; # turns metrics collection for this RouterOS device on / off
            hostname = "localhost"; # RouterOS IP address
            port = 8728; # RouterOS IP Port

            username = "username"; # RouterOS user, needs to have 'read' and 'api' permissions
            password = "password";

            credentials_file = ""; # To use an external file in YAML format for both username and password, specify the path here
            use_ssl = false; # enables connection via API-SSL servis

            no_ssl_certificate = false; # enables API_SSL connect without router SSL certificate
            ssl_certificate_verify = false; # turns SSL certificate verification on / off
            ssl_ca_file = ""; # path to the certificate authority file to validate against, leave empty to use system store
            plaintext_login = true; # for legacy RouterOS versions below 6.43 use false

            health = true; # System Health metrics
            installed_packages = true; # Installed packages
            dhcp = true; # DHCP general metrics
            dhcp_lease = true; # DHCP lease metrics

            connections = true; # IP connections metrics
            connection_stats = false; # Open IP connections metrics

            interface = true; # Interfaces traffic metrics

            route = true; # IPv4 Routes metrics
            pool = true; # IPv4 Pool metrics
            firewall = true; # IPv4 Firewall rules traffic metrics
            neighbor = true; # IPv4 Reachable Neighbors
            dns = false; # DNS stats

            ipv6_route = false; # IPv6 Routes metrics
            ipv6_pool = false; # IPv6 Pool metrics
            ipv6_firewall = false; # IPv6 Firewall rules traffic metrics
            ipv6_neighbor = false; # IPv6 Reachable Neighbors

            poe = true; # POE metrics
            monitor = true; # Interface monitor metrics
            netwatch = true; # Netwatch metrics
            public_ip = true; # Public IP metrics
            wireless = true; # WLAN general metrics
            wireless_clients = true; # WLAN clients metrics
            capsman = true; # CAPsMAN general metrics
            capsman_clients = true; # CAPsMAN clients metrics

            eoip = false; # EoIP status metrics
            gre = false; # GRE status metrics
            ipip = false; # IPIP status metrics
            lte = false; # LTE signal and status metrics (requires additional 'test' permission policy on RouterOS v6)
            ipsec = false; # IPSec active peer metrics
            switch_port = false; # Switch Port metrics

            kid_control_assigned = false; # Allow Kid Control metrics for connected devices with assigned users
            kid_control_dynamic = false; # Allow Kid Control metrics for all connected devices, including those without assigned user

            user = true; # Active Users metrics
            queue = true; # Queues metrics

            bfd = false; # BFD sessions metrics
            bgp = false; # BGP sessions metrics
            routing_stats = false; # Routing process stats
            certificate = false; # Certificates metrics

            remote_dhcp_entry = null; # An MKTXP entry to provide for remote DHCP info / resolution
            remote_capsman_entry = null; # An MKTXP entry to provide for remote capsman info

            use_comments_over_names = true; # when available, forces using comments over the interfaces names
            check_for_updates = false; # check for available ROS updates
          };
        };
      in
      pkgs.writeText "mktxp.conf" (
        toPythonINI (lib.attrsets.recursiveUpdate defaultConfiguration cfg.configuration)
      );
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
        the `configuration` option.
      '';
    };

    configuration = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = ''
        The mktxp configuration. To pass credentials, you can either

        1. set the `username` and `password` options, or
        2. use the `credentials_file` option to point to a YAML file
          containing `username` and `password` keys.

        For more info see https://github.com/akpw/mktxp

        Note that setting this option is mutually exclusive with setting
        the `configFile` option.
      '';
      example = {
        Sample-Router = {
          enabled = true;
          hostname = "192.168.0.1";
          port = 8728;

          username = "admin";
          password = "password";

          connections = true;
          lte = true;
          user = false;
        };
      };
    };

    configWritable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to make the `/var/run/mktxp/mktxp/mktxp.conf` configuration
        file writable. This can be useful if you need the `mktxp` executable
        being able to write to the configuration file.

        However, bear in mind that it will be overwritten at every start of the
        service.
      '';
    };
  };

  serviceOpts = {
    # The `mktxp` CLI requires `which` to properly initialize
    # https://github.com/akpw/mktxp/blob/f2299ee5c264bb1a3d1d2bb781a4e63495e9c641/mktxp/cli/options.py#L233
    path = [ pkgs.which ];

    # NOTE: mktxp unfortunately does not support passing a custom
    # configuration file or a custom config directory, it always reads what is
    # present in $HOME/mktxp/mktxp.conf, so we populate a dynamics user's
    # home directory with a symlink to the pure store configuration file.
    environment = {
      HOME = "/var/run/mktxp/";
    };
    preStart = ''
      mkdir -p "$HOME/mktxp"
      ${
        if cfg.configWritable then
          ''
            cp -fv "${configFile}" "$HOME/mktxp/mktxp.conf"
          ''
        else
          ''
            ln -sf "${configFile}" "$HOME/mktxp/mktxp.conf"
          ''
      }
    '';
    serviceConfig = {
      DynamicUser = true;
      RuntimeDirectory = "mktxp";
      ExecStart = "${getExe cfg.package} export ${concatStringsSep "\\\n " cfg.extraFlags}";
    };
  };
}
