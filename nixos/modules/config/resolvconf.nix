# /etc files related to networking, such as /etc/services.
{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.networking.resolvconf;

  resolvconfOptions =
    cfg.extraOptions
    ++ lib.optional cfg.dnsSingleRequest "single-request"
    ++ lib.optional cfg.dnsExtensionMechanism "edns0"
    ++ lib.optional cfg.useLocalResolver "trust-ad";

  configText = ''
    # This is the default, but we must set it here to prevent
    # a collision with an apparently unrelated environment
    # variable with the same name exported by dhcpcd.
    interface_order='lo lo[0-9]*'
  ''
  + lib.optionalString config.services.nscd.enable ''
    # Invalidate the nscd cache whenever resolv.conf is
    # regenerated.
    libc_restart='/run/current-system/systemd/bin/systemctl try-restart --no-block nscd.service 2> /dev/null'
  ''
  + lib.optionalString (lib.length resolvconfOptions > 0) ''
    # Options as described in resolv.conf(5)
    resolv_conf_options='${lib.concatStringsSep " " resolvconfOptions}'
  ''
  + lib.optionalString cfg.useLocalResolver ''
    # This hosts runs a full-blown DNS resolver.
    name_servers='127.0.0.1${lib.optionalString config.networking.enableIPv6 " ::1"}'
  ''
  + cfg.extraConfig;

in

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "networking" "dnsSingleRequest" ]
      [ "networking" "resolvconf" "dnsSingleRequest" ]
    )
    (lib.mkRenamedOptionModule
      [ "networking" "dnsExtensionMechanism" ]
      [ "networking" "resolvconf" "dnsExtensionMechanism" ]
    )
    (lib.mkRenamedOptionModule
      [ "networking" "extraResolvconfConf" ]
      [ "networking" "resolvconf" "extraConfig" ]
    )
    (lib.mkRenamedOptionModule
      [ "networking" "resolvconfOptions" ]
      [ "networking" "resolvconf" "extraOptions" ]
    )
    (lib.mkRemovedOptionModule [
      "networking"
      "resolvconf"
      "useHostResolvConf"
    ] "This option was never used for anything anyways")
  ];

  options = {

    networking.resolvconf = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = !(config.environment.etc ? "resolv.conf");
        defaultText = lib.literalExpression ''!(config.environment.etc ? "resolv.conf")'';
        description = ''
          Whether DNS configuration is managed by resolvconf.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.openresolv;
        defaultText = lib.literalExpression "pkgs.openresolv";
        description = ''
          The package that provides the system-wide resolvconf command. Defaults to `openresolv`
          if this module is enabled. Otherwise, can be used by other modules (for example {option}`services.resolved`) to
          provide a compatibility layer.

          This option generally shouldn't be set by the user.
        '';
      };

      dnsSingleRequest = lib.mkOption {
        type = lib.types.bool;
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

      dnsExtensionMechanism = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable the `edns0` option in {file}`resolv.conf`. With
          that option set, `glibc` supports use of the extension mechanisms for
          DNS (EDNS) specified in RFC 2671. The most popular user of that feature is DNSSEC,
          which does not work without it.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "libc=NO";
        description = ''
          Extra configuration to append to {file}`resolvconf.conf`.
        '';
      };

      extraOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "ndots:1"
          "rotate"
        ];
        description = ''
          Set the options in {file}`/etc/resolv.conf`.
        '';
      };

      useLocalResolver = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Use local DNS server for resolving.
        '';
      };

      subscriberFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Files written by resolvconf updates
        '';
        internal = true;
      };

    };

  };

  config = lib.mkMerge [
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

    (lib.mkIf cfg.enable {
      users.groups.resolvconf = { };

      networking.resolvconf.subscriberFiles = [ "/etc/resolv.conf" ];

      environment.systemPackages = [ cfg.package ];

      systemd.services.resolvconf = {
        description = "resolvconf update";

        before = [ "network-pre.target" ];
        wants = [ "network-pre.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ config.environment.etc."resolvconf.conf".source ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;

        script = ''
          ${lib.getExe cfg.package} -u
          chgrp resolvconf ${lib.escapeShellArgs cfg.subscriberFiles}
          chmod g=u ${lib.escapeShellArgs cfg.subscriberFiles}
          ${lib.getExe' pkgs.acl "setfacl"} -R \
            -m group:resolvconf:rwx \
            -m default:group:resolvconf:rwx \
            /run/resolvconf
        '';
      };

    })
  ];

}
