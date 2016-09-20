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
    ++ optional cfg.dnsExtensionMechanism "ends0";
in

{

  options = {

    networking.extraHosts = lib.mkOption {
      type = types.lines;
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = ''
        Additional entries to be appended to <filename>/etc/hosts</filename>.
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
      default = false;
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

    environment.etc =
      { # /etc/services: TCP/UDP port assignments.
        "services".source = pkgs.iana_etc + "/etc/services";

        # /etc/protocols: IP protocol numbers.
        "protocols".source  = pkgs.iana_etc + "/etc/protocols";

        # /etc/rpc: RPC program numbers.
        "rpc".source = pkgs.glibc.out + "/etc/rpc";

        # /etc/hosts: Hostname-to-IP mappings.
        "hosts".text =
          ''
            127.0.0.1 localhost
            ${optionalString cfg.enableIPv6 ''
              ::1 localhost
            ''}
            ${cfg.extraHosts}
          '';

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

      } // (optionalAttrs config.services.resolved.enable (
        if dnsmasqResolve then {
          "dnsmasq-resolv.conf".source = "/run/systemd/resolve/resolv.conf";
        } else {
          "resolv.conf".source = "/run/systemd/resolve/resolv.conf";
        }
      ));

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

    # The ‘ip-up’ target is kept for backwards compatibility.
    # New services should use systemd upstream targets:
    # See https://www.freedesktop.org/wiki/Software/systemd/NetworkTarget/
    systemd.targets.ip-up.description = "Services Requiring IP Connectivity (deprecated)";

    # This is needed when /etc/resolv.conf is being overriden by networkd
    # and other configurations. If the file is destroyed by an environment
    # activation then it must be rebuilt so that applications which interface
    # with /etc/resolv.conf directly don't break.
    system.activationScripts.resolvconf = stringAfter [ "etc" "tmpfs" "var" ]
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
