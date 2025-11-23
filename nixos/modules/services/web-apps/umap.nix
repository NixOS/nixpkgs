{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.services.umap;
  settingsFormat = pkgs.formats.pythonVars { };
  unixSocket = "/run/umap/umap.sock";
in
{
  options.services.umap = {
    enable = lib.mkEnableOption "Umap server";
    package = lib.mkPackageOption pkgs "umap" { };
    host = lib.mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The host name or IP address the server should listen to.";
    };
    port = lib.mkOption {
      type = types.nullOr types.port;
      default = null;
      example = 9090;
      description = "The port Umap listens on. Leave unset to use the unix socket at ${unixSocket}";
    };
    stateDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/umap";
      example = "/home/foo";
      description = "State directory of Umap.";
    };

    environmentFile = lib.mkOption {
      description = ''
        Environment file to be passed to the systemd service.
        Useful for passing secrets to the service to prevent them from being
        world-readable in the Nix store.
      '';
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/lib/secrets/umap";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          UMAP_ALLOW_ANONYMOUS = lib.mkOption {
            type = types.int;
            default = 1;
            description = "Allow anonymous map creation";
          };
          SITE_URL = lib.mkOption {
            type = types.str;
            default = "";
            description = "The final URL of you instance, including the protocol.";
            example = "http://umap.org";
          };
        };
      };
      default = { };
      description = ''
        Extra configuration options to append or override.
        For available and default option values see
        [upstream configuration file](https://docs.umap-project.org/en/stable/config/settings/)
      '';
    };

    database = {
      createLocally = lib.mkEnableOption "Create the database and database user locally." // {
        default = true;
      };

      uri = lib.mkOption {
        type = with types; nullOr str;
        default = null;
        description = "The connection URI to use. Takes priority over the configuration file if set.";
      };
    };

    nginx = {
      enable = lib.mkEnableOption "a Nginx reverse proxy for Umap." // {
        default = true;
      };
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for Umap.
        This adds `services.umap.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };
  };
  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.nginx.enable && cfg.settings.SITE_URL != "";
        message = "services.umap.settings.SITE_URL is required and must be set!";
      }
      {
        assertion = cfg.nginx.enable && cfg.port == null;
        message = "services.umap.nginx.enable is currently only compatible with unix sockets and not services.umap.port";
      }
    ];

    warnings =
      if builtins.hasAttr "SECRET_KEY" cfg.settings then
        [
          "services.umap.settings.SECRET_KEY is insecure. Either leave it empty and one will be generated or set it via services.umap.environmentFile"
        ]
      else
        [ ];

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      extensions = p: [ p.postgis ];
      ensureDatabases = [ "umap" ];
      ensureUsers = [
        {
          name = "umap";
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.umap-dbsetup = lib.mkIf cfg.database.createLocally {
      description = "Umap database setup";
      requires = [ "postgresql.target" ];
      after = [
        "network.target"
        "postgresql.target"
      ];
      script = ''
        ${config.services.postgresql.package}/bin/psql umap -c "CREATE EXTENSION IF NOT EXISTS postgis"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = config.services.postgresql.superUser;
      };
    };

    systemd.services.umap =
      let
        secretKeyFile = "${cfg.stateDir}/secretkey";
      in
      {
        description = "";
        wantedBy = [ "multi-user.target" ];
        requires = lib.optional cfg.database.createLocally "umap-dbsetup.service";
        after = [
          "network.target"
        ]
        ++ lib.optionals cfg.database.createLocally [
          "postgresql.target"
          "umap-dbsetup.service"
        ];
        path = [ cfg.package ];
        environment = {
          DATA_DIR = "${cfg.stateDir}/data";
          UMAP_SETTINGS = settingsFormat.generate "umap.conf" cfg.settings;
          DATABASE_URL =
            if cfg.database.uri != null then
              cfg.database.uri
            else
              (lib.mkIf (cfg.database.createLocally) "postgres:///umap?host=/run/postgresql&user=umap");
        };

        preStart = ''
          umap wait_for_database
          umap migrate --no-input
        ''
        + builtins.optionalString (!builtins.hasAttr "SECRET_KEY" cfg.settings) ''
          if [ -z "$SECRET_KEY" ]; then
            umap shell -c "from django.core.management.utils import get_random_secret_key; open('${secretKeyFile}', 'w').write('SECRET_KEY='+get_random_secret_key())"
          fi
        '';

        script =
          let
            networking =
              if cfg.port != null then
                "--host ${cfg.host} --port ${toString cfg.port}"
              else
                "--uds ${unixSocket}";
          in
          ''
            ${cfg.package}/bin/umap-serve --proxy-headers ${networking} --no-access-log
          '';

        serviceConfig = {
          EnvironmentFile = [
            "-${secretKeyFile}"
          ]
          ++ lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          WorkingDirectory = cfg.stateDir;
          StateDirectory = "umap";
          RuntimeDirectory = "umap";
          RuntimeDirectoryMode = "0755";
          # PrivateTmp = true;
          User = "umap";
          Group = "umap";
          DynamicUser = true;
          # DevicePolicy = "closed";
          # LockPersonality = true;
          # MemoryDenyWriteExecute = false; # onnxruntime/capi/onnxruntime_pybind11_state.so: cannot enable executable stack as shared object requires: Permission Denied
          # PrivateUsers = true;
          # ProtectHome = true;
          # ProtectHostname = true;
          # ProtectKernelLogs = true;
          # ProtectKernelModules = true;
          # ProtectKernelTunables = true;
          # ProtectControlGroups = true;
          # ProcSubset = "all"; # Error in cpuinfo: failed to parse processor information from /proc/cpuinfo
          # RestrictNamespaces = true;
          # RestrictRealtime = true;
          # SystemCallArchitectures = "native";
          # UMask = "0077";
          # CapabilityBoundingSet = "";
          # RestrictAddressFamilies = [
          #   "AF_INET"
          #   "AF_INET6"
          #   "AF_UNIX"
          # ];
          # ProtectClock = true;
          # ProtectProc = "invisible";
          # SystemCallFilter = [
          #   "@system-service"
          #   "~@privileged"
          # ];
          # SupplementaryGroups = [ "render" ]; # for rocm to access /dev/dri/renderD* devices
          # DeviceAllow = [
          #   # CUDA
          #   # https://docs.nvidia.com/dgx/pdf/dgx-os-5-user-guide.pdf
          #   "char-nvidiactl"
          #   "char-nvidia-caps"
          #   "char-nvidia-frontend"
          #   "char-nvidia-uvm"
          #   # ROCm
          #   "char-drm"
          #   "char-fb"
          #   "char-kfd"
          #   # WSL (Windows Subsystem for Linux)
          #   "/dev/dxg"
          # ];
        };
      };

    services.nginx =
      let
        urlParts = lib.splitString "://" cfg.settings.SITE_URL;
        urlProto = builtins.elemAt urlParts 0;
        urlDomain = builtins.elemAt urlParts 1;
      in
      lib.mkIf (cfg.nginx.enable && cfg.settings.SITE_URL != "") {
        enable = lib.mkDefault true;
        upstreams.umap.servers."unix:${unixSocket}" = { };
        recommendedGzipSettings = lib.mkDefault true;
        recommendedOptimisation = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;
        recommendedTlsSettings = lib.mkDefault true;
        virtualHosts."${urlDomain}" = {
          forceSSL = urlProto == "https";
          locations = {
            "/".proxyPass = "http://umap";
            "/static/" = {
              alias = "${cfg.package}/static/";
              extraConfig = ''
                access_log off;
                more_set_headers Cache-Control "public";
                expires 365d;
              '';
            };
            "/uploads/" = {
              alias = "${cfg.stateDir}/data/";
              extraConfig = ''
                access_log off;
                more_set_headers Cache-Control "public";
                expires 365d;
              '';
            };
            "/uploads/datalayer/" = {
              return = 404;
            };
          };
        };
      };

    #  location /static {
    #      autoindex off;
    #      access_log off;
    #      log_not_found off;
    #      sendfile on;
    #      gzip on;
    #      gzip_vary on;
    #      alias ${stateDir}/static/;
    #  }

    #  location /uploads {
    #      autoindex off;
    #      sendfile on;
    #      gzip on;
    #      gzip_vary on;
    #      alias ${stateDir}/data/;
    #      # Exclude direct acces to geojson, as permissions must be
    #      # checked py django.
    #      location /uploads/datalayer/ { return 404; }
    #  }

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta.maintainers =
    with lib.maintainers;
    [
      LorenzBischof
      jcollie
    ]
    ++ lib.teams.geospatial
    ++ lib.teams.ngi;
}
