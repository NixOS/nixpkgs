# /etc files related to networking, such as /etc/services.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking;
  dnsmasqResolve = config.services.dnsmasq.enable &&
                   config.services.dnsmasq.resolveLocalQueries;
  hasLocalResolver = config.services.bind.enable || dnsmasqResolve;

  resolvconfOptions = cfg.resolvconfOptions
    ++ optional cfg.dnsSingleRequest "single-request"
    ++ optional cfg.dnsExtensionMechanism "edns0";
in

{

  options = {

    networking.fqdn = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "foo.example.com";
      description = ''
        Fully qualified domain name, if any.
      '';
    };

    networking.hosts = lib.mkOption {
      type = types.attrsOf ( types.listOf types.str );
      default = {};
      example = literalExample ''
        {
          "127.0.0.1" = [ "foo.bar.baz" ];
          "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
        };
      '';
      description = ''
        Locally defined maps of hostnames to IP addresses.
      '';
    };

    networking.extraHosts = lib.mkOption {
      type = types.lines;
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = ''
        Additional verbatim entries to be appended to <filename>/etc/hosts</filename>.
      '';
    };

    networking.hostConf = lib.mkOption {
      type = types.lines;
      default = "multi on";
      example = ''
        multi on
        reorder on
        trim lan
      '';
      description = ''
        The contents of <filename>/etc/host.conf</filename>. See also <citerefentry><refentrytitle>host.conf</refentrytitle><manvolnum>5</manvolnum></citerefentry>.
      '';
    };

    networking.dnsSingleRequest = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Recent versions of glibc will issue both ipv4 (A) and ipv6 (AAAA)
        address queries at the same time, from the same port. Sometimes upstream
        routers will systemically drop the ipv4 queries. The symptom of this problem is
        that 'getent hosts example.com' only returns ipv6 (or perhaps only ipv4) addresses. The
        workaround for this is to specify the option 'single-request' in
        /etc/resolv.conf. This option enables that.
      '';
    };

    networking.dnsExtensionMechanism = lib.mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable the <code>edns0</code> option in <filename>resolv.conf</filename>. With
        that option set, <code>glibc</code> supports use of the extension mechanisms for
        DNS (EDNS) specified in RFC 2671. The most popular user of that feature is DNSSEC,
        which does not work without it.
      '';
    };

    networking.extraResolvconfConf = lib.mkOption {
      type = types.lines;
      default = "";
      example = "libc=NO";
      description = ''
        Extra configuration to append to <filename>resolvconf.conf</filename>.
      '';
    };

    networking.resolvconfOptions = lib.mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "ndots:1" "rotate" ];
      description = ''
        Set the options in <filename>/etc/resolv.conf</filename>.
      '';
    };

    networking.timeServers = mkOption {
      default = [
        "0.nixos.pool.ntp.org"
        "1.nixos.pool.ntp.org"
        "2.nixos.pool.ntp.org"
        "3.nixos.pool.ntp.org"
      ];
      description = ''
        The set of NTP servers from which to synchronise.
      '';
    };

    networking.proxy = {

      default = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          This option specifies the default value for httpProxy, httpsProxy, ftpProxy and rsyncProxy.
        '';
        example = "http://127.0.0.1:3128";
      };

      httpProxy = lib.mkOption {
        type = types.nullOr types.str;
        default = cfg.proxy.default;
        description = ''
          This option specifies the http_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      httpsProxy = lib.mkOption {
        type = types.nullOr types.str;
        default = cfg.proxy.default;
        description = ''
          This option specifies the https_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      ftpProxy = lib.mkOption {
        type = types.nullOr types.str;
        default = cfg.proxy.default;
        description = ''
          This option specifies the ftp_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      rsyncProxy = lib.mkOption {
        type = types.nullOr types.str;
        default = cfg.proxy.default;
        description = ''
          This option specifies the rsync_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      allProxy = lib.mkOption {
        type = types.nullOr types.str;
        default = cfg.proxy.default;
        description = ''
          This option specifies the all_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      noProxy = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          This option specifies the no_proxy environment variable.
          If a default proxy is used and noProxy is null,
          then noProxy will be set to 127.0.0.1,localhost.
        '';
        example = "127.0.0.1,localhost,.localdomain";
      };

      envVars = lib.mkOption {
        type = types.attrs;
        internal = true;
        default = {};
        description = ''
          Environment variables used for the network proxy.
        '';
      };
    };
  };

  config = {

    warnings = optional (cfg.extraHosts != "")
      "networking.extraHosts is deprecated, please use networking.hosts instead";

    environment.etc =
      { # /etc/services: TCP/UDP port assignments.
        "services".source = pkgs.iana-etc + "/etc/services";

        # /etc/protocols: IP protocol numbers.
        "protocols".source  = pkgs.iana-etc + "/etc/protocols";

        # /etc/rpc: RPC program numbers.
        "rpc".source = pkgs.glibc.out + "/etc/rpc";

        # /etc/hosts: Hostname-to-IP mappings.
        "hosts".text =
          let oneToString = set : ip : ip + " " + concatStringsSep " " ( getAttr ip set );
              allToString = set : concatMapStringsSep "\n" ( oneToString set ) ( attrNames set );
              userLocalHosts = optionalString
                ( builtins.hasAttr "127.0.0.1" cfg.hosts )
                ( concatStringsSep " " ( remove "localhost" cfg.hosts."127.0.0.1" ));
              userLocalHosts6 = optionalString
                ( builtins.hasAttr "::1" cfg.hosts )
                ( concatStringsSep " " ( remove "localhost" cfg.hosts."::1" ));
              otherHosts = allToString ( removeAttrs cfg.hosts [ "127.0.0.1" "::1" ]);
              maybeFQDN = optionalString ( cfg.fqdn != null ) cfg.fqdn;
          in
          ''
            127.0.0.1 ${maybeFQDN} ${userLocalHosts} localhost
            ${optionalString cfg.enableIPv6 ''
              ::1 ${maybeFQDN} ${userLocalHosts6} localhost
            ''}
            ${otherHosts}
            ${cfg.extraHosts}
          '';

        # /etc/host.conf: resolver configuration file
        "host.conf".text = cfg.hostConf;

        # /etc/resolvconf.conf: Configuration for openresolv.
        "resolvconf.conf".text =
            ''
              # This is the default, but we must set it here to prevent
              # a collision with an apparently unrelated environment
              # variable with the same name exported by dhcpcd.
              interface_order='lo lo[0-9]*'
            '' + optionalString config.services.nscd.enable ''
              # Invalidate the nscd cache whenever resolv.conf is
              # regenerated.
              libc_restart='${pkgs.systemd}/bin/systemctl try-restart --no-block nscd.service 2> /dev/null'
            '' + optionalString (length resolvconfOptions > 0) ''
              # Options as described in resolv.conf(5)
              resolv_conf_options='${concatStringsSep " " resolvconfOptions}'
            '' + optionalString hasLocalResolver ''
              # This hosts runs a full-blown DNS resolver.
              name_servers='127.0.0.1'
            '' + optionalString dnsmasqResolve ''
              dnsmasq_conf=/etc/dnsmasq-conf.conf
              dnsmasq_resolv=/etc/dnsmasq-resolv.conf
            '' + cfg.extraResolvconfConf + ''
            '';

      } // optionalAttrs config.services.resolved.enable {
        "resolv.conf".source = "/run/systemd/resolve/resolv.conf";
      } // optionalAttrs (config.services.resolved.enable && dnsmasqResolve) {
        "dnsmasq-resolv.conf".source = "/run/systemd/resolve/resolv.conf";
      };

      networking.proxy.envVars =
        optionalAttrs (cfg.proxy.default != null) {
          # other options already fallback to proxy.default
          no_proxy = "127.0.0.1,localhost";
        } // optionalAttrs (cfg.proxy.httpProxy != null) {
          http_proxy  = cfg.proxy.httpProxy;
        } // optionalAttrs (cfg.proxy.httpsProxy != null) {
          https_proxy = cfg.proxy.httpsProxy;
        } // optionalAttrs (cfg.proxy.rsyncProxy != null) {
          rsync_proxy = cfg.proxy.rsyncProxy;
        } // optionalAttrs (cfg.proxy.ftpProxy != null) {
          ftp_proxy   = cfg.proxy.ftpProxy;
        } // optionalAttrs (cfg.proxy.allProxy != null) {
          all_proxy   = cfg.proxy.allProxy;
        } // optionalAttrs (cfg.proxy.noProxy != null) {
          no_proxy    = cfg.proxy.noProxy;
        };

    # Install the proxy environment variables
    environment.sessionVariables = cfg.proxy.envVars;

    # This is needed when /etc/resolv.conf is being overriden by networkd
    # and other configurations. If the file is destroyed by an environment
    # activation then it must be rebuilt so that applications which interface
    # with /etc/resolv.conf directly don't break.
    system.activationScripts.resolvconf = stringAfter [ "etc" "specialfs" "var" ]
      ''
        # Systemd resolved controls its own resolv.conf
        rm -f /run/resolvconf/interfaces/systemd
        ${optionalString config.services.resolved.enable ''
          rm -rf /run/resolvconf/interfaces
          mkdir -p /run/resolvconf/interfaces
          ln -s /run/systemd/resolve/resolv.conf /run/resolvconf/interfaces/systemd
        ''}

        # Make sure resolv.conf is up to date if not managed by systemd
        ${optionalString (!config.services.resolved.enable) ''
          ${pkgs.openresolv}/bin/resolvconf -u
        ''}
      '';

  };

  }
