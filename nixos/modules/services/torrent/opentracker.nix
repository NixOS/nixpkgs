{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.opentracker;

  accessListFile = attr:
    if cfg."${attr}File" != null then
      cfg."${attr}File"
    else if cfg.${attr} != null then
      toString
        (pkgs.writeText
          "opentracker-${attr}.txt"
          (concatMapStrings (hash: "${hash}\n") cfg.${attr}))
    else
      null;

  blacklistFile = accessListFile "blacklist";
  whitelistFile = accessListFile "whitelist";

  overridenPkg = cfg.package.override {
    blacklist = blacklistFile != null;
    whitelist = whitelistFile != null;
    restrictStats = cfg.restrictStats.enable;
  };

  escapeColon = replaceStrings [ ":" "\\" ] [ "\\:" "\\\\" ];

  mkService = { description, RestrictAddressFamilies, pkg, configFile }: {
    inherit description;
    after = [ "network.target" ];
    requiredBy = [ "opentracker.target" ];
    partOf = [ "opentracker.target" ];
    unitConfig.ReloadPropagatedFrom = [ "opentracker.target" ];
    restartIfChanged = true;
    serviceConfig = {
      ExecStart = "${pkg}/bin/opentracker -f ${configFile}";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      PrivateTmp = true;
      RuntimeDirectory = "opentracker";
      WorkingDirectory = "/run/opentracker";
      # By default opentracker drops all privileges and runs in chroot after starting up as root.

      CapabilityBoundingSet = "CAP_SYS_CHROOT CAP_SETUID CAP_SETGID CAP_KILL";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      inherit RestrictAddressFamilies;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      BindReadOnlyPaths = optional (blacklistFile != null) "${escapeColon blacklistFile}:/run/opentracker/blacklist.txt"
                       ++ optional (whitelistFile != null) "${escapeColon whitelistFile}:/run/opentracker/whitelist.txt";
    };
  };

  mkConfig = { name, listenAddress, statsAddresses }:
    let
      config = {
        "listen.tcp_udp" = "${listenAddress}:${toString cfg.listenPort}";
        "tracker.rootdir" = ".";
        "access.blacklist" = if blacklistFile == null then [] else "blacklist.txt";
        "access.whitelist" = if whitelistFile == null then [] else "whitelist.txt";
        "access.stats" = optionals cfg.restrictStats.enable statsAddresses;
      } // cfg.extraConfig;
    in
      pkgs.writeText
        name
        (concatStrings
          (mapAttrsToList
            (name: values:
              concatMapStrings
                (value: "${name} ${value}\n")
                (toList values)
            )
            config
          )
        );
in {
  imports = [
    (mkRemovedOptionModule [ "services" "opentracker" "extraOptions" ] ''
      Use services.opentracker.extraConfig instead.
      See https://erdgeist.org/gitweb/opentracker/tree/opentracker.conf.sample
    '')
  ];

  options.services.opentracker = {
    enable = mkEnableOption (lib.mdDoc "opentracker");

    listenPort = mkOption {
      type = types.port;
      description = mdDoc ''
        Port number to bind to.
      '';
      default = 6969;
    };

    listenAddress.ipv4 = mkOption {
      type = with types; nullOr string;
      description = mdDoc ''
        IPv4 address to bind to. Set to null to disable IPv4 server.
      '';
      default = "0.0.0.0";
    };

    listenAddress.ipv6 = mkOption {
      type = with types; nullOr string;
      description = mdDoc ''
        IPv6 address to bind to. Set to null to disable IPv6 server.
      '';
      default = "::";
      example = "::1";
    };

    restrictStats = {
      enable = mkOption {
        type = types.bool;
        description = mdDoc ''
          Restrict access to tracker statistics.
        '';
        default = false;
      };

      allow.ipv4 = mkOption {
        type = with types; listOf string;
        description = mdDoc ''
          Allow these IPv4 addresses to access stats.
        '';
        default = [];
      };

      allow.ipv6 = mkOption {
        type = with types; listOf string;
        description = mdDoc ''
          Allow these IPv6 addresses to access stats.
        '';
        default = [];
        example = [ "::1" ];
      };
    };

    blacklist = mkOption {
      type = with types; nullOr (listOf string);
      description = mdDoc ''
        Do not track torrents with these hashes.
      '';
      default = null;
    };

    blacklistFile = mkOption {
      type = with types; nullOr path;
      description = mdDoc ''
        Do not track torrents with the hashes from this file.
      '';
      default = null;
    };

    whitelist = mkOption {
      type = with types; nullOr (listOf string);
      description = mdDoc ''
        Only track torrents with these hashes.
      '';
      default = null;
    };

    whitelistFile = mkOption {
      type = with types; nullOr path;
      description = mdDoc ''
        Only track torrents with the hashes from this file.
      '';
      default = null;
    };

    package = mkPackageOption pkgs "opentracker" {};

    extraConfig = mkOption {
      type = with types; attrsOf (oneOf [ string (listOf string) ]);
      description = mdDoc ''
        Configuration options for opentracker
        See <https://erdgeist.org/gitweb/opentracker/tree/opentracker.conf.sample> for all params
      '';
      default = {};
      example = {
        "tracker.redirect_url" = "https://nixos.org/";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.listenAddress.ipv4 != null || cfg.listenAddress.ipv6 != null;
        message = ''
          config.opentracker.listenAddress.ipv4 or config.opentracker.listenAddress.ipv6
          must be non-null.
        '';
      }
      { assertion = blacklistFile == null || whitelistFile == null;
        message = "Cannot use whitelist and blacklist at the same time.";
      }
    ];

    systemd.services = (optionalAttrs (cfg.listenAddress.ipv4 != null) {
      opentracker-v4 = mkService {
        description = "opentracker IPv4 server";
        RestrictAddressFamilies = "AF_INET";
        pkg = overridenPkg.override { ipv6 = false; };
        configFile = mkConfig {
          name = "opentracker-v4.conf";
          listenAddress = cfg.listenAddress.ipv4;
          statsAddresses = cfg.restrictStats.allow.ipv4;
        };
      };
    }) // (optionalAttrs (cfg.listenAddress.ipv6 != null) {
      opentracker-v6 = mkService {
        description = "opentracker IPv6 server";
        RestrictAddressFamilies = "AF_INET6";
        pkg = overridenPkg.override { ipv6 = true; };
        configFile = mkConfig {
          name = "opentracker-v6.conf";
          listenAddress = "[${cfg.listenAddress.ipv6}]";
          statsAddresses = cfg.restrictStats.allow.ipv6;
        };
      };
    });

    systemd.targets.opentracker = {
      description = "opentracker server";
      wantedBy = [ "multi-user.target" ];
    };
  };
}

