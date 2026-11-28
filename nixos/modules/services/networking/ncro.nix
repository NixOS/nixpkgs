{
  config,
  pkgs,
  lib,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  tomlType = tomlFormat.type;

  checkable = pkgs.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform;

  generateConfig =
    name: settings:
    let
      file = tomlFormat.generate name settings;
    in
    if checkable then
      pkgs.runCommand name { } ''
        ${lib.getExe' cfg.package "ncro"} --config ${file} --check
        cp ${file} $out
      ''
    else
      file;

  cfg = config.services.ncro;
  defaultServerPort = 8080;
  defaultMeshPort = 7946;
  configFile = generateConfig "ncro.toml" effectiveSettings;

  # Normalize a ncro listen address (`:port` shorthand) to the
  # `host:port` format expected by systemd's ListenStream.
  normalizeAddr = addr: if lib.strings.hasPrefix ":" addr then "0.0.0.0${addr}" else addr;

  addrParts =
    addr:
    let
      matches = lib.strings.match "(.*):([0-9]+)" addr;
    in
    if matches == null then
      throw "ncro address ${addr} must end in a numeric port"
    else
      {
        host = lib.lists.elemAt matches 0;
        port = lib.strings.toInt (lib.lists.elemAt matches 1);
      };

  portOfAddr = addr: (addrParts addr).port;

  # systemd's ListenStream takes neither a hostname nor the `:port` shorthand,
  # so spell out the sockets ncro would otherwise bind itself.
  listenStreamsFor =
    addr:
    let
      port = builtins.toString (portOfAddr addr);
    in
    if lib.strings.hasPrefix "localhost:" addr then
      [
        "127.0.0.1:${port}"
        "[::1]:${port}"
      ]
    else if lib.strings.hasPrefix ":" addr then
      [ port ]
    else
      [ addr ];

  isLoopbackAddr =
    addr:
    let
      inherit ((addrParts addr)) host;
    in
    host == "localhost" || host == "::1" || host == "[::1]" || lib.strings.hasPrefix "127." host;

  publicKeysFor =
    upstream:
    lib.lists.optional ((upstream.public_key or "") != "") upstream.public_key
    ++ (upstream.public_keys or [ ]);

  upstreamPublicKeysFor =
    settings:
    let
      fallbackPublicKeys =
        if settings.fallback_cache.enabled or false then
          publicKeysFor (
            settings.fallback_cache
            // {
              public_key =
                settings.fallback_cache.public_key
                  or "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
            }
          )
        else
          [ ];
    in
    lib.pipe ((settings.upstreams or [ ]) ++ [ fallbackPublicKeys ]) [
      (lib.lists.map (upstream: if builtins.isAttrs upstream then publicKeysFor upstream else upstream))
      lib.lists.flatten
      (lib.lists.filter (key: key != ""))
      lib.lists.unique
    ];

  instanceConfigFile =
    name: instance: generateConfig "ncro-${name}.toml" (effectiveInstanceSettings instance);

  instanceWrapper = pkgs.writeShellScript "ncro-instance" ''
    if [ -s "$CREDENTIALS_DIRECTORY/netrc" ]; then
      export NETRC="$CREDENTIALS_DIRECTORY/netrc"
    fi
    exec ${lib.getExe' cfg.package "ncro"} --config "/etc/ncro/$1.toml"
  '';

  instanceService = {
    description = "Nix Cache Route Optimizer instance %i";
    after = [ "network.target" ];
    environment.NCRO_DB_PATH = "/var/lib/ncro-%i/routes.db";
    serviceConfig = {
      ExecStart = "${instanceWrapper} %i";
      Type = "notify";
      DynamicUser = true;
      StateDirectory = "ncro-%i";
      LoadCredential = [ "netrc:/etc/ncro/%i.netrc" ];
      Restart = "on-failure";
      RestartSec = "5s";

      # NAR proxying is not concurrency-gated: every in-flight NAR holds an
      # inbound and an upstream socket for the duration of the transfer, so a
      # single busy nix client can exceed systemd's 1024 soft limit.
      LimitNOFILE = 65536;

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
        "AF_NETLINK"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      SystemCallFilter = [ "@system-service" ];
      SystemCallArchitectures = "native";
    };
  };

  listenAddrFor =
    fallbackPort: settings:
    if (settings.server.listen or "") != "" then
      settings.server.listen
    else
      "localhost:${builtins.toString fallbackPort}";

  meshAddrFor =
    fallbackPort: settings:
    if (settings.mesh.bind_addr or "") != "" then
      settings.mesh.bind_addr
    else
      "0.0.0.0:${builtins.toString fallbackPort}";

  effectiveSettingsFor =
    serverPort: meshPort: settings:
    lib.attrsets.recursiveUpdate settings {
      server.listen = listenAddrFor serverPort settings;
      mesh.bind_addr = meshAddrFor meshPort settings;
    };

  effectiveSettings = effectiveSettingsFor cfg.port cfg.meshPort cfg.settings;
  effectiveInstanceSettings =
    instance:
    effectiveSettingsFor (lib.trivial.defaultTo defaultServerPort instance.port)
      (lib.trivial.defaultTo defaultMeshPort instance.meshPort)
      instance.settings;

  instanceSocket = _: instance: {
    wantedBy = [ "sockets.target" ];
    socketConfig.ListenStream = listenStreamsFor (effectiveInstanceSettings instance).server.listen;
  };

  activeListeners =
    if cfg.instances == { } then
      [
        {
          settings = effectiveSettings;
          openFirewall = cfg.openFirewall;
        }
      ]
    else
      lib.attrsets.mapAttrsToList (_: instance: {
        settings = effectiveInstanceSettings instance;
        openFirewall = cfg.openFirewall || instance.openFirewall;
      }) cfg.instances;

  firewallListeners = lib.lists.filter (listener: listener.openFirewall) activeListeners;

  firewallTCPPorts = lib.lists.unique (
    lib.lists.map (listener: portOfAddr listener.settings.server.listen) (
      lib.lists.filter (listener: !isLoopbackAddr listener.settings.server.listen) firewallListeners
    )
  );

  firewallUDPPorts = lib.lists.unique (
    lib.lists.map (listener: portOfAddr listener.settings.mesh.bind_addr) (
      lib.lists.filter (
        listener:
        (listener.settings.mesh.enabled or false) && !isLoopbackAddr listener.settings.mesh.bind_addr
      ) firewallListeners
    )
  );

  instanceListenAddresses = lib.lists.flatten (
    lib.attrsets.mapAttrsToList (
      _: instance: listenStreamsFor (effectiveInstanceSettings instance).server.listen
    ) cfg.instances
  );

  instanceMeshAddresses = lib.lists.map (settings: normalizeAddr settings.mesh.bind_addr) (
    lib.lists.filter (settings: settings.mesh.enabled or false) (
      lib.attrsets.mapAttrsToList (_: effectiveInstanceSettings) cfg.instances
    )
  );

  upstreamPublicKeys = lib.lists.unique (
    upstreamPublicKeysFor effectiveSettings
    ++ lib.lists.flatten (
      builtins.map (instance: upstreamPublicKeysFor (effectiveInstanceSettings instance)) (
        lib.attrsets.attrValues cfg.instances
      )
    )
  );

  instanceEtc =
    lib.attrsets.mapAttrs' (
      name: instance:
      lib.attrsets.nameValuePair "ncro/${name}.toml" { source = instanceConfigFile name instance; }
    ) cfg.instances
    // lib.attrsets.mapAttrs' (
      name: instance:
      lib.attrsets.nameValuePair "ncro/${name}.netrc" {
        source = if instance.netrcFile != null then instance.netrcFile else pkgs.writeText "empty-netrc" "";
      }
    ) cfg.instances;
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
        Append non-empty upstream public_key and public_keys values from
        {option}`services.ncro.settings` to
        {option}`nix.settings.trusted-public-keys`.

        This keeps Nix client signature validation aligned with the upstream
        caches that ncro is allowed to route to. Disable this if you manage
        Nix trusted public keys separately.
      '';
    };

    socketActivation = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable systemd socket activation for ncro. When enabled, systemd
        creates and holds the listening TCP socket, starting ncro on the first
        incoming connection.

        ncro signals readiness via {manpage}`sd_notify(3)`, so downstream
        units that declare `After = ncro.service` will not start until ncro is
        actually accepting connections.

        A {manpage}`systemd.socket(5)` unit `ncro.socket` is created
        automatically. The listen address is taken from
        {option}`services.ncro.settings.server.listen` if set, otherwise from
        {option}`services.ncro.port`.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = defaultServerPort;
      description = ''
        TCP port for the ncro HTTP listener, bound on `localhost` (both
        127.0.0.1 and ::1) unless overridden. Reach for
        {option}`services.ncro.settings.server.listen` when you need to pin
        the bind address too, since it overrides this option.
      '';
    };

    meshPort = lib.mkOption {
      type = lib.types.port;
      default = defaultMeshPort;
      description = ''
        UDP port for mesh gossip. Reach for
        {option}`services.ncro.settings.mesh.bind_addr` when you need to pin
        the bind address too, since it overrides this option.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the firewall for whichever ports the listeners actually landed
        on, across every named instance as well. Mesh gossip is included only
        when mesh is enabled, and a listener bound to loopback is skipped
        since nothing outside the machine can reach one anyway.
      '';
    };

    package = lib.mkPackageOption pkgs "ncro" { };

    netrcFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/etc/nix/netrc";
      description = ''
        The path to netrc file for upstream authentication.
        If null, ncro will not use netrc for upstream authentication.
      '';
    };

    settings = lib.mkOption {
      type = tomlType;
      default = { };
      description = ''
        ncro configuration as an attribute set.

        Keys are the TOML field names, and anything left out keeps ncro's
        own default. The generated file is checked with `ncro --check` at
        build time, so a misspelt key or an out-of-range value fails the
        build rather than the running service.
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

    instances = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { ... }: {
            options = {
              port = lib.mkOption {
                type = lib.types.nullOr lib.types.port;
                default = null;
                example = 8081;
                description = ''
                  TCP port for this instance, which is enough on its own to give
                  the instance a listen address. Setting `settings.server.listen`
                  overrides it.
                '';
              };

              meshPort = lib.mkOption {
                type = lib.types.nullOr lib.types.port;
                default = null;
                example = 7947;
                description = ''
                  UDP port for this instance's mesh gossip. Setting
                  `settings.mesh.bind_addr` overrides it. Instances that enable
                  mesh each need a port of their own.
                '';
              };

              openFirewall = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Open the firewall for this instance alone, on the same terms as
                  the toplevel {option}`services.ncro.openFirewall`, which covers
                  every instance at once.
                '';
              };

              settings = lib.mkOption {
                type = tomlType;
                default = { };
                description = "Configuration for this ncro instance.";
              };

              socketActivation = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable systemd socket activation for this instance.";
              };

              netrcFile = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = ''
                  Netrc file for upstream authentication in this instance.
                '';
              };
            };
          }
        )
      );
      default = { };
      description = ''
        Named ncro instances. Each instance starts the `ncro@.service` template
        as `ncro@<name>.service`, with its own
        state directory, SQLite route cache, and optionally socket unit.
        Every instance must set `port` or `settings.server.listen` to a unique
        address, and mesh-enabled instances must likewise use unique
        `meshPort` or `settings.mesh.bind_addr` values.
      '';
      example.project = {
        settings = {
          server.listen = "127.0.0.1:8081";
          upstreams = [ { url = "https://cache.nixos.org"; } ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.trusted-public-keys = lib.mkIf cfg.addUpstreamPublicKeys (
      lib.mkAfter upstreamPublicKeys
    );

    assertions =
      (lib.attrsets.mapAttrsToList (name: instance: {
        assertion = instance.port != null || (instance.settings.server.listen or "") != "";
        message = "services.ncro.instances.${name} needs either port or settings.server.listen";
      }) cfg.instances)
      ++ (lib.attrsets.mapAttrsToList (name: _: {
        assertion = builtins.match "[a-zA-Z0-9_.-]+" name != null;
        message = "services.ncro.instances names may contain only letters, numbers, '.', '_', and '-'";
      }) cfg.instances)
      ++ [
        {
          assertion =
            builtins.length instanceListenAddresses
            == builtins.length (lib.lists.unique instanceListenAddresses);
          message = "services.ncro.instances must use unique listen addresses (port or settings.server.listen)";
        }
        {
          assertion =
            builtins.length instanceMeshAddresses == builtins.length (lib.lists.unique instanceMeshAddresses);
          message = "services.ncro.instances with mesh enabled must use unique mesh addresses (meshPort or settings.mesh.bind_addr)";
        }
      ];

    networking.firewall = lib.mkIf (firewallTCPPorts != [ ] || firewallUDPPorts != [ ]) {
      allowedTCPPorts = firewallTCPPorts;
      allowedUDPPorts = firewallUDPPorts;
    };

    environment.etc = instanceEtc;
    systemd = {
      sockets = {
        ncro = lib.mkIf (cfg.instances == { } && cfg.socketActivation) {
          wantedBy = [ "sockets.target" ];
          socketConfig.ListenStream = listenStreamsFor effectiveSettings.server.listen;
        };
      }
      // lib.attrsets.mapAttrs' (
        name: instance: lib.attrsets.nameValuePair "ncro@${name}" (instanceSocket name instance)
      ) (lib.attrsets.filterAttrs (_: instance: instance.socketActivation) cfg.instances);

      services = {
        ncro = lib.mkIf (cfg.instances == { }) {
          description = "Nix Cache Route Optimizer";
          wantedBy = [ "multi-user.target" ];
          after = if cfg.socketActivation then [ "ncro.socket" ] else [ "network.target" ];
          requires = lib.lists.optionals cfg.socketActivation [ "ncro.socket" ];
          environment = lib.attrsets.optionalAttrs (cfg.netrcFile != null) {
            NETRC = "%d/netrc";
          };
          serviceConfig = {
            ExecStart = "${lib.getExe' cfg.package "ncro"} --config ${configFile}";
            DynamicUser = true;
            StateDirectory = "ncro";
            Restart = "on-failure";
            RestartSec = "5s";

            # NAR proxying is not concurrency-gated: every in-flight NAR holds an
            # inbound and an upstream socket for the duration of the transfer, so a
            # single busy nix client can exceed systemd's 1024 soft limit.
            LimitNOFILE = 65536;

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
            ++ lib.lists.optionals cfg.socketActivation [ "AF_UNIX" ];
            RestrictNamespaces = true;
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            SystemCallFilter = [ "@system-service" ];
            SystemCallArchitectures = "native";
          }
          // lib.attrsets.optionalAttrs cfg.socketActivation { Type = "notify"; }
          // lib.attrsets.optionalAttrs (cfg.netrcFile != null) {
            LoadCredential = [ "netrc:${cfg.netrcFile}" ];
          };
        };
        "ncro@" = lib.mkIf (cfg.instances != { }) instanceService;
      };

      targets.multi-user.wants = lib.lists.map (name: "ncro@${name}.service") (
        lib.attrsets.attrNames (
          lib.attrsets.filterAttrs (_: instance: !instance.socketActivation) cfg.instances
        )
      );
    };
  };
}
