# /etc files related to networking, such as /etc/services.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking;

  localhostMultiple = any (elem "localhost") (attrValues (removeAttrs cfg.hosts [ "127.0.0.1" "::1" ]));

in

{
  imports = [
    (mkRemovedOptionModule [ "networking" "hostConf" ] "Use environment.etc.\"host.conf\" instead.")
  ];

  options = {

    networking.hosts = lib.mkOption {
      type = types.attrsOf (types.listOf types.str);
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

    networking.hostFiles = lib.mkOption {
      type = types.listOf types.path;
      defaultText = lib.literalExample "Hosts from `networking.hosts` and `networking.extraHosts`";
      example = lib.literalExample ''[ "''${pkgs.my-blocklist-package}/share/my-blocklist/hosts" ]'';
      description = ''
        Files that should be concatenated together to form <filename>/etc/hosts</filename>.
      '';
    };

    networking.extraHosts = lib.mkOption {
      type = types.lines;
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = ''
        Additional verbatim entries to be appended to <filename>/etc/hosts</filename>.
        For adding hosts from derivation results, use <option>networking.hostFiles</option> instead.
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
        optional (cfg.hostName != "" && cfg.domain != null) "${cfg.hostName}.${cfg.domain}"
        ++ optional (cfg.hostName != "") cfg.hostName; # Then the hostname (without the domain)
    in {
      "127.0.0.2" = hostnames;
    } // optionalAttrs cfg.enableIPv6 {
      "::1" = hostnames;
    };

    networking.hostFiles = let
      # Note: localhostHosts has to appear first in /etc/hosts so that 127.0.0.1
      # resolves back to "localhost" (as some applications assume) instead of
      # the FQDN! By default "networking.hosts" also contains entries for the
      # FQDN so that e.g. "hostname -f" works correctly.
      localhostHosts = pkgs.writeText "localhost-hosts" ''
        127.0.0.1 localhost
        ${optionalString cfg.enableIPv6 "::1 localhost"}
      '';
      stringHosts =
        let
          oneToString = set: ip: ip + " " + concatStringsSep " " set.${ip} + "\n";
          allToString = set: concatMapStrings (oneToString set) (attrNames set);
        in pkgs.writeText "string-hosts" (allToString (filterAttrs (_: v: v != []) cfg.hosts));
      extraHosts = pkgs.writeText "extra-hosts" cfg.extraHosts;
    in mkBefore [ localhostHosts stringHosts extraHosts ];

    environment.etc =
      { # /etc/services: TCP/UDP port assignments.
        services.source = pkgs.iana-etc + "/etc/services";

        # /etc/protocols: IP protocol numbers.
        protocols.source  = pkgs.iana-etc + "/etc/protocols";

        # /etc/hosts: Hostname-to-IP mappings.
        hosts.source = pkgs.runCommandNoCC "hosts" {} ''
          cat ${escapeShellArgs cfg.hostFiles} > $out
        '';

        # /etc/host.conf: resolver configuration file
        "host.conf".text = ''
          multi on
        '';

      } // optionalAttrs (pkgs.stdenv.hostPlatform.libc == "glibc") {
        # /etc/rpc: RPC program numbers.
        rpc.source = pkgs.stdenv.cc.libc.out + "/etc/rpc";
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

  };

}
