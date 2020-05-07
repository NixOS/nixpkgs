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
    };

    networking.resolvconf.useLocalResolver = mkDefault true;


    environment.etc."unbound/unbound.conf".source = confFile;

    systemd.services.unbound = {
      description = "Unbound recursive Domain Name Server";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wants = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];

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

        AmbientCapabilities = [
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
          "CAP_SETGID"
          "CAP_SETUID"
          "CAP_SYS_CHROOT"
          "CAP_SYS_RESOURCE"
        ];

        User = "unbound";

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
        ReadWritePaths = [ "/run/unbound" "${stateDir}" ];
      };
    };
    # If networkmanager is enabled, ask it to interface with unbound.
    networking.networkmanager.dns = "unbound";
  };
}
