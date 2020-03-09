# /etc files related to networking, such as /etc/services.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.resolvconf;

  resolvconfOptions = cfg.extraOptions
    ++ optional cfg.dnsSingleRequest "single-request"
    ++ optional cfg.dnsExtensionMechanism "edns0";

  configText =
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
    '' + optionalString cfg.useLocalResolver ''
      # This hosts runs a full-blown DNS resolver.
      name_servers='127.0.0.1'
    '' + cfg.extraConfig;

in

{
  imports = [
    (mkRenamedOptionModule [ "networking" "dnsSingleRequest" ] [ "networking" "resolvconf" "dnsSingleRequest" ])
    (mkRenamedOptionModule [ "networking" "dnsExtensionMechanism" ] [ "networking" "resolvconf" "dnsExtensionMechanism" ])
    (mkRenamedOptionModule [ "networking" "extraResolvconfConf" ] [ "networking" "resolvconf" "extraConfig" ])
    (mkRenamedOptionModule [ "networking" "resolvconfOptions" ] [ "networking" "resolvconf" "extraOptions" ])
    (mkRemovedOptionModule [ "networking" "resolvconf" "useHostResolvConf" ] "This option was never used for anything anyways")
  ];

  options = {

    networking.resolvconf = {

      enable = mkOption {
        type = types.bool;
        default = false;
        internal = true;
        description = ''
          DNS configuration is managed by resolvconf.
        '';
      };

      dnsSingleRequest = lib.mkOption {
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

      dnsExtensionMechanism = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable the <code>edns0</code> option in <filename>resolv.conf</filename>. With
          that option set, <code>glibc</code> supports use of the extension mechanisms for
          DNS (EDNS) specified in RFC 2671. The most popular user of that feature is DNSSEC,
          which does not work without it.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = "libc=NO";
        description = ''
          Extra configuration to append to <filename>resolvconf.conf</filename>.
        '';
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "ndots:1" "rotate" ];
        description = ''
          Set the options in <filename>/etc/resolv.conf</filename>.
        '';
      };

      useLocalResolver = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use local DNS server for resolving.
        '';
      };

    };

  };

  config = mkMerge [
    {
      networking.resolvconf.enable = !(config.environment.etc ? "resolv.conf");

      environment.etc."resolvconf.conf".text =
        if !cfg.enable then
          # Force-stop any attempts to use resolvconf
          ''
            echo "resolvconf is disabled on this system but was used anyway:" >&2
            echo "$0 $*" >&2
            exit 1
          ''
        else configText;
    }

    (mkIf cfg.enable {
      environment.systemPackages = [ pkgs.openresolv ];

      systemd.services.resolvconf = {
        description = "resolvconf update";

        before = [ "network-pre.target" ];
        wants = [ "network-pre.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ config.environment.etc."resolvconf.conf".source ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.openresolv}/bin/resolvconf -u";
          RemainAfterExit = true;
        };
      };

    })
  ];

}
