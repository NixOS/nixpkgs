{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.bazarr;

  secretType = lib.types.attrTag {
    _secret = lib.mkOption {
      type = lib.types.either lib.types.externalPath (lib.types.listOf lib.types.externalPath);
    };
  };
  secretCheck =
    v:
    secretType.check v
    || lib.isList v && lib.any secretCheck v
    || lib.isAttrs v && lib.any secretCheck (lib.attrValues v);
  settingsType =
    lib.types.oneOf [
      secretType
      (lib.types.attrsOf settingsType)
      (lib.types.addCheck lib.types.json (v: !secretCheck v))
    ]
    // {
      description = "${lib.types.json.description}, where an attribute value may instead be an ${secretType.description}";
    };

  settings = lib.pipe cfg.settings [
    (lib.mapAttrsToListRecursiveCond (_: as: !secretType.check as) lib.nameValuePair)
    (lib.partition ({ value, ... }: secretType.check value))
  ];
  secretSettings = map ({ name, value }: lib.nameValuePair name value._secret) settings.right;

  envName = name: "DYNACONF_${lib.join "__" name}";
  environment = lib.pipe settings.wrong [
    (map ({ name, value }: lib.nameValuePair (envName name) "@json ${lib.toJSON value}"))
    lib.listToAttrs
  ];

  mapSecret =
    f:
    { name, value }:
    let
      id = lib.join "." name;
    in
    if lib.isList value then lib.imap0 (i: f "${id}.${toString i}") value else f id value;

  secretFiles = lib.flip lib.pipe [
    (mapSecret (id: _: "--rawfile ${id} $CREDENTIALS_DIRECTORY/${id}"))
    toString
  ];
  secretTemplate = lib.flip lib.pipe [
    (mapSecret (id: _: id))
    lib.toJSON
    lib.escapeShellArg
  ];
  secretScript = lib.concatMapStrings (
    setting@{ name, ... }:
    ''
      ${envName name}="@json $(
        ${lib.getExe pkgs.jq} --compact-output \
        ${secretFiles setting} \
        '(.. | strings) |= ($ARGS.named[.] | trim)' \
        <<<${secretTemplate setting}
      )"
      export ${envName name}
    ''
  ) secretSettings;

  credentials = lib.pipe secretSettings [
    (map (mapSecret (id: value: "${id}:${value}")))
    lib.flatten
  ];
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "bazarr" "listenPort" ]
      [ "services" "bazarr" "settings" "general" "port" ]
    )
  ];

  options = {
    services.bazarr = {
      enable = lib.mkEnableOption "bazarr, a subtitle manager for Sonarr and Radarr";

      package = lib.mkPackageOption pkgs "bazarr" { };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/bazarr";
        description = "The directory where Bazarr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the bazarr web interface.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "bazarr";
        description = "User account under which bazarr runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "bazarr";
        description = "Group under which bazarr runs.";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsType;
          options = {
            analytics.enabled = lib.mkEnableOption "sending anonymous usage statistics to Bazarr's developers";

            general = {
              auto_update = lib.mkOption {
                type = lib.types.bool;
                default = false;
                readOnly = true;
                description = ''
                  Whether Bazarr self-updates.
                  Always `false`, because the package is managed by Nix.
                '';
              };

              port = lib.mkOption {
                type = lib.types.port;
                default = 6767;
                description = "Port on which the Bazarr web interface listens.";
              };
            };
          };
        };
        default = { };
        description = ''
          Bazarr configuration.
          Settings are emitted as `DYNACONF_*` environment variables at startup,
          overriding any value previously written by Bazarr's web UI to `config.yaml`.

          Use `_secret` to load values from files via systemd's `LoadCredential=`.
          Secret contents are exported into Bazarr's environment at service start,
          as either a string or a list of strings.
        '';
        example = {
          general = {
            instance_name = "NixOS Bazarr";
            port = 12345;
          };
          auth.apikey._secret = "/run/secrets/bazarr-apikey";
          translator.gemini_keys._secret = [
            "/run/secrets/bazarr-gemini-key-0"
            "/run/secrets/bazarr-gemini-key-1"
          ];
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-bazarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.bazarr = {
      description = "Bazarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      inherit environment;
      script = ''
        ${secretScript}
        exec ${lib.getExe cfg.package} ${
          lib.cli.toCommandLineShellGNU { } {
            config = cfg.dataDir;
            no-update = true;
          }
        }
      '';

      serviceConfig = {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
        SyslogIdentifier = "bazarr";
        Restart = "on-failure";
        KillSignal = "SIGINT";
        SuccessExitStatus = "0 156";
        LoadCredential = credentials;

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateTmp = "disconnected";
        PrivateUsers = true;
        ProcSubset = "pid";
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
      };
      unitConfig.RequiresMountsFor = [ cfg.dataDir ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.general.port ];
    };

    users.users = lib.mkIf (cfg.user == "bazarr") {
      bazarr = {
        inherit (cfg) group;
        isSystemUser = true;
        home = cfg.dataDir;
      };
    };

    users.groups = lib.mkIf (cfg.group == "bazarr") {
      bazarr = { };
    };
  };

  meta.maintainers = with lib.maintainers; [
    connor-grady
    diogotcorreia
  ];
}
