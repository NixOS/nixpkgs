# /etc files related to networking, such as /etc/services.
{ config, lib, options, pkgs, ... }:
let

  cfg = config.networking;
  opt = options.networking;

  localhostMultiple = lib.any (lib.elem "localhost") (lib.attrValues (removeAttrs cfg.hosts [ "127.0.0.1" "::1" ]));

in

{
  imports = [
    (lib.mkRemovedOptionModule [ "networking" "hostConf" ] "Use environment.etc.\"host.conf\" instead.")
  ];

  options = {

    networking.hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      example = lib.literalExpression ''
        {
          "127.0.0.1" = [ "foo.bar.baz" ];
          "192.168.0.2" = [ "fileserver.local" "nameserver.local" ];
        };
      '';
      description = ''
        Locally defined maps of hostnames to IP addresses.
      '';
    };

    networking.hostFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      defaultText = lib.literalMD "Hosts from {option}`networking.hosts` and {option}`networking.extraHosts`";
      example = lib.literalExpression ''[ "''${pkgs.my-blocklist-package}/share/my-blocklist/hosts" ]'';
      description = ''
        Files that should be concatenated together to form {file}`/etc/hosts`.
      '';
    };

    networking.extraHosts = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = ''
        Additional verbatim entries to be appended to {file}`/etc/hosts`.
        For adding hosts from derivation results, use {option}`networking.hostFiles` instead.
      '';
    };

    networking.timeServers = lib.mkOption {
      default = [
        "0.nixos.pool.ntp.org"
        "1.nixos.pool.ntp.org"
        "2.nixos.pool.ntp.org"
        "3.nixos.pool.ntp.org"
      ];
      type = lib.types.listOf lib.types.str;
      description = ''
        The set of NTP servers from which to synchronise.
      '';
    };

    networking.proxy = {

      default = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          This option specifies the default value for httpProxy, httpsProxy, ftpProxy and rsyncProxy.
        '';
        example = "http://127.0.0.1:3128";
      };

      httpProxy = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = cfg.proxy.default;
        defaultText = lib.literalExpression "config.${opt.proxy.default}";
        description = ''
          This option specifies the http_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      httpsProxy = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = cfg.proxy.default;
        defaultText = lib.literalExpression "config.${opt.proxy.default}";
        description = ''
          This option specifies the https_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      ftpProxy = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = cfg.proxy.default;
        defaultText = lib.literalExpression "config.${opt.proxy.default}";
        description = ''
          This option specifies the ftp_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      rsyncProxy = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = cfg.proxy.default;
        defaultText = lib.literalExpression "config.${opt.proxy.default}";
        description = ''
          This option specifies the rsync_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      allProxy = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = cfg.proxy.default;
        defaultText = lib.literalExpression "config.${opt.proxy.default}";
        description = ''
          This option specifies the all_proxy environment variable.
        '';
        example = "http://127.0.0.1:3128";
      };

      noProxy = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          This option specifies the no_proxy environment variable.
          If a default proxy is used and noProxy is null,
          then noProxy will be set to 127.0.0.1,localhost.
        '';
        example = "127.0.0.1,localhost,.localdomain";
      };

      envVars = lib.mkOption {
        type = lib.types.attrs;
        internal = true;
        default = {};
        description = ''
          Environment variables used for the network proxy.
        '';
      };
    };
  };

  config = {

    assertions = [{
      assertion = !localhostMultiple;
      message = ''
        `networking.hosts` maps "localhost" to something other than "127.0.0.1"
        or "::1". This will break some applications. Please use
        `networking.extraHosts` if you really want to add such a mapping.
      '';
    }];

    # These entries are required for "hostname -f" and to resolve both the
    # hostname and FQDN correctly:
    networking.hosts = let
      hostnames = # Note: The FQDN (canonical hostname) has to come first:
        lib.optional (cfg.hostName != "" && cfg.domain != null) "${cfg.hostName}.${cfg.domain}"
        ++ lib.optional (cfg.hostName != "") cfg.hostName; # Then the hostname (without the domain)
    in {
      "127.0.0.2" = hostnames;
    } // lib.optionalAttrs cfg.enableIPv6 {
      "::1" = hostnames;
    };

    networking.hostFiles = let
      # Note: localhostHosts has to appear first in /etc/hosts so that 127.0.0.1
      # resolves back to "localhost" (as some applications assume) instead of
      # the FQDN! By default "networking.hosts" also contains entries for the
      # FQDN so that e.g. "hostname -f" works correctly.
      localhostHosts = pkgs.writeText "localhost-hosts" ''
        127.0.0.1 localhost
        ${lib.optionalString cfg.enableIPv6 "::1 localhost"}
      '';
      stringHosts =
        let
          oneToString = set: ip: ip + " " + lib.concatStringsSep " " set.${ip} + "\n";
          allToString = set: lib.concatMapStrings (oneToString set) (lib.attrNames set);
        in pkgs.writeText "string-hosts" (allToString (lib.filterAttrs (_: v: v != []) cfg.hosts));
      extraHosts = pkgs.writeText "extra-hosts" cfg.extraHosts;
    in lib.mkBefore [ localhostHosts stringHosts extraHosts ];

    environment.etc =
      { # /etc/services: TCP/UDP port assignments.
        services.source = pkgs.iana-etc + "/etc/services";

        # /etc/protocols: IP protocol numbers.
        protocols.source  = pkgs.iana-etc + "/etc/protocols";

        # /etc/hosts: Hostname-to-IP mappings.
        hosts.source = pkgs.concatText "hosts" cfg.hostFiles;

        # /etc/netgroup: Network-wide groups.
        netgroup.text = lib.mkDefault "";

        # /etc/host.conf: resolver configuration file
        "host.conf".text = ''
          multi on
        '';

      } // lib.optionalAttrs (pkgs.stdenv.hostPlatform.libc == "glibc") {
        # /etc/rpc: RPC program numbers.
        rpc.source = pkgs.stdenv.cc.libc.out + "/etc/rpc";
      };

      networking.proxy.envVars =
        lib.optionalAttrs (cfg.proxy.default != null) {
          # other options already fallback to proxy.default
          no_proxy = "127.0.0.1,localhost";
        } // lib.optionalAttrs (cfg.proxy.httpProxy != null) {
          http_proxy  = cfg.proxy.httpProxy;
        } // lib.optionalAttrs (cfg.proxy.httpsProxy != null) {
          https_proxy = cfg.proxy.httpsProxy;
        } // lib.optionalAttrs (cfg.proxy.rsyncProxy != null) {
          rsync_proxy = cfg.proxy.rsyncProxy;
        } // lib.optionalAttrs (cfg.proxy.ftpProxy != null) {
          ftp_proxy   = cfg.proxy.ftpProxy;
        } // lib.optionalAttrs (cfg.proxy.allProxy != null) {
          all_proxy   = cfg.proxy.allProxy;
        } // lib.optionalAttrs (cfg.proxy.noProxy != null) {
          no_proxy    = cfg.proxy.noProxy;
        };

    # Install the proxy environment variables
    environment.sessionVariables = cfg.proxy.envVars;

  };

}
