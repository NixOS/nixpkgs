{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.unbound;

  yesOrNo = v: if v then "yes" else "no";

  toOption = indent: n: v: "${indent}${toString n}: ${v}";

  toConf = indent: n: v:
    if builtins.isFloat v then (toOption indent n (builtins.toJSON v))
    else if isInt v       then (toOption indent n (toString v))
    else if isBool v      then (toOption indent n (yesOrNo v))
    else if isString v    then (toOption indent n v)
    else if isList v      then (concatMapStringsSep "\n" (toConf indent n) v)
    else if isAttrs v     then (concatStringsSep "\n" (
                                  ["${indent}${n}:"] ++ (
                                    mapAttrsToList (toConf "${indent}  ") v
                                  )
                                ))
    else throw (traceSeq v "services.unbound.settings: unexpected type");

  confNoServer = concatStringsSep "\n" ((mapAttrsToList (toConf "") (builtins.removeAttrs cfg.settings [ "server" ])) ++ [""]);
  confServer = concatStringsSep "\n" (mapAttrsToList (toConf "  ") (builtins.removeAttrs cfg.settings.server [ "define-tag" ]));

  confFileUnchecked = pkgs.writeText "unbound.conf" ''
    server:
    ${optionalString (cfg.settings.server.define-tag != "") (toOption "  " "define-tag" cfg.settings.server.define-tag)}
    ${confServer}
    ${confNoServer}
  '';
  confFile = if cfg.checkconf then pkgs.runCommandLocal "unbound-checkconf" { } ''
    cp ${confFileUnchecked} unbound.conf

    # fake stateDir which is not accessible in the sandbox
    mkdir -p $PWD/state
    sed -i unbound.conf \
      -e '/auto-trust-anchor-file/d' \
      -e "s|${cfg.stateDir}|$PWD/state|"
    ${cfg.package}/bin/unbound-checkconf unbound.conf

    cp ${confFileUnchecked} $out
  '' else confFileUnchecked;

  rootTrustAnchorFile = "${cfg.stateDir}/root.key";

in {

  ###### interface

  options = {
    services.unbound = {

      enable = mkEnableOption "Unbound domain name server";

      package = mkPackageOption pkgs "unbound-with-systemd" { };

      user = mkOption {
        type = types.str;
        default = "unbound";
        description = "User account under which unbound runs.";
      };

      group = mkOption {
        type = types.str;
        default = "unbound";
        description = "Group under which unbound runs.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/unbound";
        description = "Directory holding all state for unbound to run.";
      };

      checkconf = mkOption {
        type = types.bool;
        default = !cfg.settings ? include && !cfg.settings ? remote-control;
        defaultText = "!services.unbound.settings ? include && !services.unbound.settings ? remote-control";
        description = ''
          Whether to check the resulting config file with unbound checkconf for syntax errors.

          If settings.include is used, this options is disabled, as the import can likely not be accessed at build time.
          If settings.remote-control is used, this option is disabled, too as the control-key-file, server-cert-file and server-key-file cannot be accessed at build time.
        '';
      };

      resolveLocalQueries = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether unbound should resolve local queries (i.e. add 127.0.0.1 to
          /etc/resolv.conf).
        '';
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
          When not set to `null` this option defines the path
          at which the unbound remote control socket should be created at. The
          socket will be owned by the unbound user (`unbound`)
          and group will be `nogroup`.

          Users that should be permitted to access the socket must be in the
          `config.services.unbound.group` group.

          If this option is `null` remote control will not be
          enabled. Unbounds default values apply.
        '';
      };

      settings = mkOption {
        default = {};
        type = with types; submodule {

          freeformType = let
            validSettingsPrimitiveTypes = oneOf [ int str bool float ];
            validSettingsTypes = oneOf [ validSettingsPrimitiveTypes (listOf validSettingsPrimitiveTypes) ];
            settingsType = oneOf [ str (attrsOf validSettingsTypes) ];
          in attrsOf (oneOf [ settingsType (listOf settingsType) ])
              // { description = ''
                unbound.conf configuration type. The format consist of an attribute
                set of settings. Each settings can be either one value, a list of
                values or an attribute set. The allowed values are integers,
                strings, booleans or floats.
              '';
            };

          options = {
            remote-control.control-enable = mkOption {
              type = bool;
              default = false;
              internal = true;
            };
          };
        };
        example = literalExpression ''
          {
            server = {
              interface = [ "127.0.0.1" ];
            };
            forward-zone = [
              {
                name = ".";
                forward-addr = "1.1.1.1@853#cloudflare-dns.com";
              }
              {
                name = "example.org.";
                forward-addr = [
                  "1.1.1.1@853#cloudflare-dns.com"
                  "1.0.0.1@853#cloudflare-dns.com"
                ];
              }
            ];
            remote-control.control-enable = true;
          };
        '';
        description = ''
          Declarative Unbound configuration
          See the {manpage}`unbound.conf(5)` manpage for a list of
          available options.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    services.unbound.settings = {
      server = {
        directory = mkDefault cfg.stateDir;
        username = ''""'';
        chroot = ''""'';
        pidfile = ''""'';
        # when running under systemd there is no need to daemonize
        do-daemonize = false;
        interface = mkDefault ([ "127.0.0.1" ] ++ (optional config.networking.enableIPv6 "::1"));
        access-control = mkDefault ([ "127.0.0.0/8 allow" ] ++ (optional config.networking.enableIPv6 "::1/128 allow"));
        auto-trust-anchor-file = mkIf cfg.enableRootTrustAnchor rootTrustAnchorFile;
        tls-cert-bundle = mkDefault "/etc/ssl/certs/ca-certificates.crt";
        # prevent race conditions on system startup when interfaces are not yet
        # configured
        ip-freebind = mkDefault true;
        define-tag = mkDefault "";
      };
      remote-control = {
        control-enable = mkDefault false;
        control-interface = mkDefault ([ "127.0.0.1" ] ++ (optional config.networking.enableIPv6 "::1"));
        server-key-file = mkDefault "${cfg.stateDir}/unbound_server.key";
        server-cert-file = mkDefault "${cfg.stateDir}/unbound_server.pem";
        control-key-file = mkDefault "${cfg.stateDir}/unbound_control.key";
        control-cert-file = mkDefault "${cfg.stateDir}/unbound_control.pem";
      } // optionalAttrs (cfg.localControlSocketPath != null) {
        control-enable = true;
        control-interface = cfg.localControlSocketPath;
      };
    };

    environment.systemPackages = [ cfg.package ];

    users.users = mkIf (cfg.user == "unbound") {
      unbound = {
        description = "unbound daemon user";
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = mkIf (cfg.group == "unbound") {
      unbound = {};
    };

    networking = mkIf cfg.resolveLocalQueries {
      resolvconf = {
        useLocalResolver = mkDefault true;
      };
    };

    environment.etc."unbound/unbound.conf".source = confFile;

    systemd.services.unbound = {
      description = "Unbound recursive Domain Name Server";
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" "nss-lookup.target" ];

      path = mkIf cfg.settings.remote-control.control-enable [ pkgs.openssl ];

      preStart = ''
        ${optionalString cfg.enableRootTrustAnchor ''
          ${cfg.package}/bin/unbound-anchor -a ${rootTrustAnchorFile} || echo "Root anchor updated!"
        ''}
        ${optionalString cfg.settings.remote-control.control-enable ''
          ${cfg.package}/bin/unbound-control-setup -d ${cfg.stateDir}
        ''}
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
          "CAP_NET_RAW" # needed if ip-transparent is set to true
        ];
        CapabilityBoundingSet = [
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];

        User = cfg.user;
        Group = cfg.group;

        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectSystem = "strict";
        ProtectClock = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        RuntimeDirectory = "unbound";
        ConfigurationDirectory = "unbound";
        StateDirectory = "unbound";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_NETLINK" "AF_UNIX" ];
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictSUIDSGID = true;

        ReadWritePaths = [ cfg.stateDir ];

        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "unbound" "interfaces" ] [ "services" "unbound" "settings" "server" "interface" ])
    (mkChangedOptionModule [ "services" "unbound" "allowedAccess" ] [ "services" "unbound" "settings" "server" "access-control" ] (
      config: map (value: "${value} allow") (getAttrFromPath [ "services" "unbound" "allowedAccess" ] config)
    ))
    (mkRemovedOptionModule [ "services" "unbound" "forwardAddresses" ] ''
      Add a new setting:
      services.unbound.settings.forward-zone = [{
        name = ".";
        forward-addr = [ # Your current services.unbound.forwardAddresses ];
      }];
      If any of those addresses are local addresses (127.0.0.1 or ::1), you must
      also set services.unbound.settings.server.do-not-query-localhost to false.
    '')
    (mkRemovedOptionModule [ "services" "unbound" "extraConfig" ] ''
      You can use services.unbound.settings to add any configuration you want.
    '')
  ];
}
