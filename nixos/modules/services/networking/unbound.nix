{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.unbound;

  stateDir = "/var/lib/unbound";

  access = concatMapStringsSep "\n  " (x: "access-control: ${x} allow") cfg.allowedAccess;

  interfaces = concatMapStringsSep "\n  " (x: "interface: ${x}") cfg.interfaces;

  isLocalAddress = x: substring 0 3 x == "::1" || substring 0 9 x == "127.0.0.1";

  forward =
    optionalString (any isLocalAddress cfg.forwardAddresses) ''
      do-not-query-localhost: no
    ''
    + optionalString (cfg.forwardAddresses != []) ''
      forward-zone:
        name: .
    ''
    + concatMapStringsSep "\n" (x: "    forward-addr: ${x}") cfg.forwardAddresses;

  rootTrustAnchorFile = "${stateDir}/root.key";

  trustAnchor = optionalString cfg.enableRootTrustAnchor
    "auto-trust-anchor-file: ${rootTrustAnchorFile}";

  confFile = pkgs.writeText "unbound.conf" ''
    server:
      ip-freebind: yes
      directory: "${stateDir}"
      username: unbound
      chroot: ""
      pidfile: ""
      # when running under systemd there is no need to daemonize
      do-daemonize: no
      ${interfaces}
      ${access}
      ${trustAnchor}
    ${lib.optionalString (cfg.localControlSocketPath != null) ''
      remote-control:
        control-enable: yes
        control-interface: ${cfg.localControlSocketPath}
    ''}
    ${cfg.extraConfig}
    ${forward}
  '';
in
{

  ###### interface

  options = {
    services.unbound = {

      enable = mkEnableOption "Unbound domain name server";

      package = mkOption {
        type = types.package;
        default = pkgs.unbound-with-systemd;
        defaultText = "pkgs.unbound-with-systemd";
        description = "The unbound package to use";
      };

      allowedAccess = mkOption {
        default = [ "127.0.0.0/24" ];
        type = types.listOf types.str;
        description = "What networks are allowed to use unbound as a resolver.";
      };

      interfaces = mkOption {
        default = [ "127.0.0.1" ] ++ optional config.networking.enableIPv6 "::1";
        type = types.listOf types.str;
        description =  ''
          What addresses the server should listen on. This supports the interface syntax documented in
          <citerefentry><refentrytitle>unbound.conf</refentrytitle><manvolnum>8</manvolnum></citerefentry>.
        '';
      };

      forwardAddresses = mkOption {
        default = [];
        type = types.listOf types.str;
        description = "What servers to forward queries to.";
      };

      enableRootTrustAnchor = mkOption {
        default = true;
        type = types.bool;
        description = "Use and update root trust anchor for DNSSEC validation.";
      };

      localControlSocketPath = mkOption {
        default = null;
        # FIXME: What is the proper type here so users can specify strings,
        # paths and null?
        # My guess would be `types.nullOr (types.either types.str types.path)`
        # but I haven't verified yet.
        type = types.nullOr types.str;
        example = "/run/unbound/unbound.ctl";
        description = ''
          When not set to <literal>null</literal> this option defines the path
          at which the unbound remote control socket should be created at. The
          socket will be owned by the unbound user (<literal>unbound</literal>)
          and group will be <literal>nogroup</literal>.

          Users that should be permitted to access the socket must be in the
          <literal>unbound</literal> group.

          If this option is <literal>null</literal> remote control will not be
          configured at all. Unbounds default values apply.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra unbound config. See
          <citerefentry><refentrytitle>unbound.conf</refentrytitle><manvolnum>8
          </manvolnum></citerefentry>.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    users.users.unbound = {
      description = "unbound daemon user";
      isSystemUser = true;
      group = lib.mkIf (cfg.localControlSocketPath != null) (lib.mkDefault "unbound");
    };

    # We need a group so that we can give users access to the configured
    # control socket. Unbound allows access to the socket only to the unbound
    # user and the primary group.
    users.groups = lib.mkIf (cfg.localControlSocketPath != null) {
      unbound = {};
    };

    networking.resolvconf.useLocalResolver = mkDefault true;


    environment.etc."unbound/unbound.conf".source = confFile;

    systemd.services.unbound = {
      description = "Unbound recursive Domain Name Server";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" "nss-lookup.target" ];

      preStart = lib.mkIf cfg.enableRootTrustAnchor ''
        ${cfg.package}/bin/unbound-anchor -a ${rootTrustAnchorFile} || echo "Root anchor updated!"
      '';

      restartTriggers = [
        confFile
      ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/unbound -p -d -c /etc/unbound/unbound.conf";
        ExecReload = "+/run/current-system/sw/bin/kill -HUP $MAINPID";

        NotifyAccess = "main";
        Type = "notify";

        # FIXME: Which of these do we actualy need, can we drop the chroot flag?
        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
          "CAP_SETGID"
          "CAP_SETUID"
          "CAP_SYS_CHROOT"
          "CAP_SYS_RESOURCE"
        ];

        User = "unbound";
        Group = lib.mkIf (cfg.localControlSocketPath != null) (lib.mkDefault "unbound");

        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectSystem = "strict";
        RuntimeDirectory = "unbound";
        ConfigurationDirectory = "unbound";
        StateDirectory = "unbound";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@clock"
          "@cpu-emulation"
          "@debug"
          "@keyring"
          "@module"
          "mount"
          "@obsolete"
          "@resources"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictSUIDSGID = true;
      };
    };
    # If networkmanager is enabled, ask it to interface with unbound.
    networking.networkmanager.dns = "unbound";
  };
}
