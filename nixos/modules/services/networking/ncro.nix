{
  config,
  pkgs,
  lib,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  tomlType = tomlFormat.type;

  cfg = config.services.ncro;
  configFile = tomlFormat.generate "ncro.toml" cfg.settings;

  # Normalize a ncro listen address (`:port` shorthand) to the
  # `host:port` format expected by systemd's ListenStream.
  toListenStream =
    addr:
    let
      raw = if addr == "" then ":8080" else addr;
    in
    if lib.hasPrefix ":" raw then "0.0.0.0${raw}" else raw;

  fallbackPublicKeys = lib.optional (cfg.settings.fallback_cache.enabled or false) (
    cfg.settings.fallback_cache.public_key
      or "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  );

  upstreamPublicKeys = lib.pipe ((cfg.settings.upstreams or [ ]) ++ fallbackPublicKeys) [
    (map (upstream: if builtins.isAttrs upstream then upstream.public_key or "" else upstream))
    (builtins.filter (key: key != ""))
    lib.unique
  ];
in
{
  meta.maintainers = with lib.maintainers; [
    amaanq
    atagen
    faukah
    max
    NotAShelf
  ];

  options.services.ncro = {
    enable = lib.mkEnableOption "ncro, the Nix cache route optimizer";

    addUpstreamPublicKeys = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Append non-empty upstream public_key values from {option}`services.ncro.settings`
        to {option}`nix.settings.trusted-public-keys`.

        This keeps Nix client signature validation aligned with the upstream
        caches that ncro is allowed to route to. Disable this if you manage Nix
        trusted public keys separately.
      '';
    };

    socketActivation = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable systemd socket activation for ncro. When enabled, systemd
        creates and holds the listening TCP socket, starting ncro on the first
        incoming connection.

        ncro signals readiness via {manpage}`sd_notify(3)`, so downstream units
        that declare `After = ncro.service` will not start until ncro is actually
        accepting connections.

        A {manpage}`systemd.socket(5)` unit `ncro.socket` is created automatically.
        The listen address is taken from {option}`services.ncro.settings.server.listen`
        if set, defaulting to `:8080`.
      '';
    };

    package = lib.mkPackageOption pkgs "nh" { };

    settings = lib.mkOption {
      type = tomlType;
      default = { };
      description = ''
        ncro configuration as an attribute set.

        Keys and structure match the TOML config file format; all defaults are
        handled by the ncro binary.
      '';
      example = {
        logging.level = "info";
        server = {
          listen = ":8080";
          cache_priority = 20;
        };

        upstreams = [
          {
            url = "https://cache.nixos.org";
            priority = 10;
          }
          {
            url = "https://nix-community.cachix.org";
            priority = 20;
          }
        ];

        cache = {
          ttl = "2h";
          negative_ttl = "15m";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.trusted-public-keys = lib.mkIf cfg.addUpstreamPublicKeys (
      lib.mkAfter upstreamPublicKeys
    );

    systemd.sockets.ncro = lib.mkIf cfg.socketActivation {
      wantedBy = [ "sockets.target" ];
      socketConfig.ListenStream = toListenStream (cfg.settings.server.listen or "");
    };

    systemd.services.ncro = {
      description = "Nix Cache Route Optimizer";
      wantedBy = [ "multi-user.target" ];
      after = if cfg.socketActivation then [ "ncro.socket" ] else [ "network.target" ];
      requires = lib.optionals cfg.socketActivation [ "ncro.socket" ];
      serviceConfig = {
        ExecStart = "${lib.getExe' cfg.package "ncro"} --config ${configFile}";
        DynamicUser = true;
        StateDirectory = "ncro";
        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectProc = "invisible";
        ProtectHostname = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        RestrictRealtime = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK" # required by mdns-sd and system resolver
        ]
        # sd_notify uses a Unix datagram socket to signal readiness.
        ++ lib.optional cfg.socketActivation "AF_UNIX";
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        SystemCallFilter = [ "@system-service" ];
        SystemCallArchitectures = "native";
      }
      // lib.optionalAttrs cfg.socketActivation { Type = "notify"; };
    };
  };
}
