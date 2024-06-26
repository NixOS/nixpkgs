# /etc files related to networking, such as /etc/services.

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.networking.resolvconf;

  resolvconfOptions =
    cfg.extraOptions
    ++ optional cfg.dnsSingleRequest "single-request"
    ++ optional cfg.dnsExtensionMechanism "edns0"
    ++ optional cfg.useLocalResolver "trust-ad";

  configText =
    ''
      # This is the default, but we must set it here to prevent
      # a collision with an apparently unrelated environment
      # variable with the same name exported by dhcpcd.
      interface_order='lo lo[0-9]*'
    ''
    + optionalString config.services.nscd.enable ''
      # Invalidate the nscd cache whenever resolv.conf is
      # regenerated.
      libc_restart='/run/current-system/systemd/bin/systemctl try-restart --no-block nscd.service 2> /dev/null'
    ''
    + optionalString (length resolvconfOptions > 0) ''
      # Options as described in resolv.conf(5)
      resolv_conf_options='${concatStringsSep " " resolvconfOptions}'
    ''
    + optionalString cfg.useLocalResolver ''
      # This hosts runs a full-blown DNS resolver.
      name_servers='127.0.0.1${optionalString config.networking.enableIPv6 " ::1"}'
    ''
    + cfg.extraConfig;

in

{
  imports = [
    (mkRenamedOptionModule
      [
        "networking"
        "dnsSingleRequest"
      ]
      [
        "networking"
        "resolvconf"
        "dnsSingleRequest"
      ]
    )
    (mkRenamedOptionModule
      [
        "networking"
        "dnsExtensionMechanism"
      ]
      [
        "networking"
        "resolvconf"
        "dnsExtensionMechanism"
      ]
    )
    (mkRenamedOptionModule
      [
        "networking"
        "extraResolvconfConf"
      ]
      [
        "networking"
        "resolvconf"
        "extraConfig"
      ]
    )
    (mkRenamedOptionModule
      [
        "networking"
        "resolvconfOptions"
      ]
      [
        "networking"
        "resolvconf"
        "extraOptions"
      ]
    )
    (mkRemovedOptionModule [
      "networking"
      "resolvconf"
      "useHostResolvConf"
    ] "This option was never used for anything anyways")
  ];

  options = {

    networking.resolvconf = {

      enable = mkOption {
        type = types.bool;
        default = !(config.environment.etc ? "resolv.conf");
        defaultText = literalExpression ''!(config.environment.etc ? "resolv.conf")'';
        description = ''
          Whether DNS configuration is managed by resolvconf.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.openresolv;
        defaultText = literalExpression "pkgs.openresolv";
        description = ''
          The package that provides the system-wide resolvconf command. Defaults to `openresolv`
          if this module is enabled. Otherwise, can be used by other modules (for example {option}`services.resolved`) to
          provide a compatibility layer.

          This option generally shouldn't be set by the user.
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
          Enable the `edns0` option in {file}`resolv.conf`. With
          that option set, `glibc` supports use of the extension mechanisms for
          DNS (EDNS) specified in RFC 2671. The most popular user of that feature is DNSSEC,
          which does not work without it.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = "libc=NO";
        description = ''
          Extra configuration to append to {file}`resolvconf.conf`.
        '';
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [
          "ndots:1"
          "rotate"
        ];
        description = ''
          Set the options in {file}`/etc/resolv.conf`.
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
      environment.etc."resolvconf.conf".text =
        if !cfg.enable then
          # Force-stop any attempts to use resolvconf
          ''
            echo "resolvconf is disabled on this system but was used anyway:" >&2
            echo "$0 $*" >&2
            exit 1
          ''
        else
          configText;
    }

    (mkIf cfg.enable {
      networking.resolvconf.package = pkgs.openresolv;

      environment.systemPackages = [ cfg.package ];

      systemd.services.resolvconf = {
        description = "resolvconf update";

        before = [ "network-pre.target" ];
        wants = [ "network-pre.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ config.environment.etc."resolvconf.conf".source ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package}/bin/resolvconf -u";
          RemainAfterExit = true;
        };
      };

    })
  ];

}
