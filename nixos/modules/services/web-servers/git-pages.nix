{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.git-pages;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "git-pages.toml" cfg.settings;

  # An endpoint is `<protocol>/<address>`, split on the first `/`, and the
  # single dash `-` disables the listener. Give the TCP port when there is one,
  # and `null` for a unix socket or a disabled listener.
  endpointPort =
    endpoint:
    let
      protocol = lib.head (lib.splitString "/" endpoint);
      address = lib.concatStringsSep "/" (lib.tail (lib.splitString "/" endpoint));
      port = lib.last (lib.splitString ":" address);
    in
    if
      lib.elem protocol [
        "tcp"
        "tcp4"
        "tcp6"
      ]
      && builtins.match "[0-9]+" port != null
    then
      lib.toInt port
    else
      null;

  listenPorts = lib.filter (port: port != null) (
    map endpointPort (lib.attrValues cfg.settings.server)
  );
  pagesPort = endpointPort cfg.settings.server.pages;
  needsNetBindService = lib.any (port: port < 1024) listenPorts;
in
{
  meta.maintainers = with lib.maintainers; [ kiara ];

  options.services.git-pages = {
    enable = lib.mkEnableOption "git-pages, a static site server for Git forges";

    package = lib.mkPackageOption pkgs "git-pages" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the port of
        {option}`services.git-pages.settings.server.pages`.

        This has no effect while that listener keeps its default address, which
        accepts connections from localhost only. The
        {option}`services.git-pages.settings.server.caddy` and
        {option}`services.git-pages.settings.server.metrics` endpoints stay
        closed; they are for a reverse proxy and for a metrics scraper on the
        same host.
      '';
    };

    secretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/git-pages.toml";
      description = ''
        Path to a TOML file, outside the world-readable Nix store, that is
        layered over {option}`services.git-pages.settings`. It takes the same
        keys, and the values in it win.

        Use it for the credentials of an S3 storage backend. The file is passed
        to the service as a systemd credential, so it is readable by root only.
      '';
    };

    nginx.virtualHosts = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (import ./nginx/vhost-options.nix { inherit config lib; })
      );
      example = lib.literalExpression ''
        {
          "pages.example.org" = {
            serverAliases = [ "*.pages.example.org" ];
            enableACME = true;
            forceSSL = true;
          };
        }
      '';
      description = ''
        nginx virtual hosts that proxy to
        {option}`services.git-pages.settings.server.pages`. Each one gets the
        proxy configuration that git-pages needs, and you can add TLS and the
        other virtual host settings here. Set this and nginx replaces the Caddy
        server that git-pages carries.

        git-pages selects a site by the host name of the request, so a virtual
        host serves the site of its own name. Add each site as a server alias,
        or use one wildcard alias.

        An upload goes through the same virtual host, so
        {option}`services.nginx.clientMaxBodySize` must be as large as the
        largest site.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Configuration for git-pages, written to a TOML file. See
        <https://git-pages.org/running-a-server/#configuration> for the
        available settings.

        git-pages rejects a key it does not know, so a typo stops the service
        from starting.
      '';
      example = lib.literalExpression ''
        {
          server.pages = "tcp/:8080";
          wildcard = [
            {
              domain = "pages.example.org";
              clone-url = "https://git.example.org/<user>/<project>.git";
              authorization = "forgejo";
            }
          ];
        }
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options.server = {
          pages = lib.mkOption {
            type = lib.types.str;
            default = "tcp/localhost:3000";
            example = "tcp/:8080";
            description = ''
              Endpoint that serves the static sites, as `<protocol>/<address>`.
              Put a reverse proxy in front of it to terminate TLS. Set it to
              `-` to disable the listener.
            '';
          };

          caddy = lib.mkOption {
            type = lib.types.str;
            default = "tcp/localhost:3001";
            description = ''
              Endpoint that answers the `on_demand_tls` permission requests of
              a Caddy reverse proxy. Set it to `-` to disable the listener.
            '';
          };

          metrics = lib.mkOption {
            type = lib.types.str;
            default = "tcp/localhost:3002";
            description = ''
              Endpoint that serves Prometheus metrics under `/metrics`. Set it
              to `-` to disable the listener.
            '';
          };
        };

        options.storage.fs.root = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/git-pages";
          description = ''
            Directory for the `fs` storage backend. The default is the state
            directory that systemd creates for the service.

            The service runs under a `DynamicUser`, so another directory must
            be writable by the `git-pages` group, and must be listed in
            {option}`systemd.services.git-pages.serviceConfig.ReadWritePaths`.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.nginx.virtualHosts != { } -> pagesPort != null;
        message = ''
          services.git-pages.nginx.virtualHosts needs a TCP endpoint in
          services.git-pages.settings.server.pages to proxy to.
        '';
      }
    ];

    systemd.services.git-pages = {
      description = "Static site server for Git forges";
      documentation = [ "https://git-pages.org/running-a-server/" ];

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.concatStringsSep " " (
          [
            (lib.getExe cfg.package)
            "-config"
            configFile
          ]
          ++ lib.optionals (cfg.secretFile != null) [
            "-secrets"
            "%d/secrets.toml"
          ]
        );
        LoadCredential = lib.optional (cfg.secretFile != null) "secrets.toml:${cfg.secretFile}";

        DynamicUser = true;

        Restart = "always";
        RestartSec = "10s";

        StateDirectory = "git-pages";
        # git-pages resolves a relative `[storage.fs] root` against the working
        # directory, and unpacks an upload through `$TMPDIR`.
        WorkingDirectory = "%S/git-pages";
        PrivateTmp = true;

        # systemd service hardening
        AmbientCapabilities = lib.optional needsNetBindService "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = if needsNetBindService then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };

    services.nginx = lib.mkIf (cfg.nginx.virtualHosts != { } && pagesPort != null) {
      enable = lib.mkDefault true;
      virtualHosts = lib.mapAttrs (
        _name: vhost:
        lib.mkMerge [
          (lib.mapAttrsRecursive (_: lib.mkDefault) vhost)
          {
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString pagesPort}";
              # git-pages selects a site by the host name of the request, which
              # these settings keep.
              recommendedProxySettings = true;
              # `git-pages-cli` does not accept an upload unless the `Server`
              # response header reads `git-pages`. nginx sends its own name in
              # that header if you do not pass the header of the upstream
              # through.
              extraConfig = "proxy_pass_header Server;";
            };
          }
        ]
      ) cfg.nginx.virtualHosts;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall (
      lib.optional (pagesPort != null) pagesPort
    );
  };
}
