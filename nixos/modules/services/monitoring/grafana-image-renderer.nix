{
  lib,
  pkgs,
  config,
  utils,
  ...
}:
let
  cfg = config.services.grafana-image-renderer;

  format = {
    type =
      with lib.types;
      attrsOf (
        attrsOf (oneOf [
          str
          int
          bool
          (listOf (oneOf [
            str
            int
          ]))
        ])
      );

    generate = lib.flip lib.pipe [
      # Remove legacy option prefixes that only exist for backwards-compat
      (lib.flip builtins.removeAttrs [
        "service"
        "rendering"
        "assertions"
        "warnings"
      ])

      # Normalize CLI args from a nested attr-set to `section.option = value`
      (lib.concatMapAttrs (block: lib.mapAttrs' (option: lib.nameValuePair "${block}.${option}")))

      # Turn attr-set into a list of arguments, denormalize list options.
      (lib.mapAttrsToList (
        option: value:
        if lib.isBool value then
          lib.optional value "--${option}"
        else if lib.isList value then
          map (v: [
            "--${option}"
            v
          ]) value
        else
          [
            "--${option}"
            (toString value)
          ]
      ))
      lib.flatten

      # Turn into a string
      utils.escapeSystemdExecArgs
    ];
  };
in
{
  imports = [
    (lib.mkChangedOptionModule
      [
        "services"
        "grafana-image-renderer"
        "chromium"
      ]
      [
        "services"
        "grafana-image-renderer"
        "settings"
        "browser"
        "path"
      ]
      (config: lib.getExe config.services.grafana-image-renderer.chromium)
    )
    (lib.mkRemovedOptionModule
      [
        "services"
        "grafana-image-renderer"
        "verbose"
      ]
      ''
        Use `services.grafana-image-renderer.settings.log.level = "debug"` instead.
      ''
    )
  ];

  options.services.grafana-image-renderer = {
    enable = lib.mkEnableOption "grafana-image-renderer";

    provisionGrafana = lib.mkEnableOption "Grafana configuration for grafana-image-renderer";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        imports = [
          ../../misc/assertions.nix
          (lib.mkRenamedOptionModule
            [
              "rendering"
              "width"
            ]
            [
              "browser"
              "min-width"
            ]
          )
          (lib.mkRenamedOptionModule
            [
              "rendering"
              "height"
            ]
            [
              "browser"
              "min-height"
            ]
          )
          (lib.mkRenamedOptionModule
            [
              "rendering"
              "args"
            ]
            [

              "browser"
              "flag"
            ]
          )
          (lib.mkChangedOptionModule
            [
              "service"
              "port"
            ]
            [
              "server"
              "addr"
            ]
            (config: "0.0.0.0:${toString config.service.port}")
          )
          (lib.mkRemovedOptionModule
            [
              "rendering"
              "mode"
            ]
            ''
              This option is obsolete.
            ''
          )
          (lib.mkRenamedOptionModule
            [
              "service"
              "logging"
            ]
            [
              "log"
            ]
          )
        ];

        options = {
          server.addr = lib.mkOption {
            type = lib.types.str;
            default = "localhost:8081";
            description = ''
              Listen address of the service.
            '';
          };
          browser.path = lib.mkOption {
            type = lib.types.path;
            default = lib.getExe pkgs.chromium;
            defaultText = lib.literalExpression "lib.getExe pkgs.chromium";
            description = ''
              Path to the executable of the chromium to use.
            '';
          };
        };
      };

      default = { };

      description = ''
        Configuration attributes for `grafana-image-renderer`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.provisionGrafana -> config.services.grafana.enable;
        message = ''
          To provision a Grafana instance to use grafana-image-renderer,
          `services.grafana.enable` must be set to `true`!
        '';
      }
    ];

    services.grafana.settings.rendering = lib.mkIf cfg.provisionGrafana {
      server_url = "http://${toString cfg.settings.server.addr}/render";
      callback_url = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
    };

    services.grafana-image-renderer.settings = {
      browser.timezone = lib.mkIf (config.time.timeZone != null) (lib.mkDefault config.time.timeZone);
    };

    systemd.services.grafana-image-renderer = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      description = "Grafana backend plugin that handles rendering of panels & dashboards to PNGs using headless browser (Chromium/Chrome)";

      serviceConfig = {
        DynamicUser = true;
        PrivateTmp = true;
        ExecStart = "${lib.getExe pkgs.grafana-image-renderer} server ${format.generate cfg.settings}";
        Restart = "always";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 27;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ma27 ];
}
