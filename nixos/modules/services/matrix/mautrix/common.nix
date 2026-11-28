{ lib, pkgs }:
let
  format = pkgs.formats.json { };

  logging = {
    min_level = "info";
    writers = [
      {
        type = "stdout";
        format = "pretty-colored";
        time_format = " ";
      }
    ];
  };

  sandbox = {
    LockPersonality = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectSystem = "strict";
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallErrorNumber = "EPERM";
    SystemCallFilter = [ "@system-service" ];
    UMask = "0077";
  };

  substituteConfig = pkgs.writers.writePython3Bin "mautrix-substitute-config" { } (
    builtins.readFile ./substitute-config.py
  );

  generateRegistration = pkgs.writeShellApplication {
    name = "mautrix-generate-registration";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.yq
      substituteConfig
    ];
    text = builtins.readFile ./generate-registration.sh;
  };

  resolveDataDir =
    dataDir:
    lib.removeSuffix "/" (if lib.hasPrefix "/" dataDir then dataDir else "/var/lib/${dataDir}");

  formatHost = host: if lib.hasInfix ":" host && !(lib.hasPrefix "[" host) then "[${host}]" else host;

  connectHost =
    rawHost:
    let
      host = lib.removePrefix "[" (lib.removeSuffix "]" rawHost);
    in
    if host == "" || host == "0.0.0.0" then
      "127.0.0.1"
    else if host == "::" then
      "[::1]"
    else
      formatHost host;

  defaultDependencies =
    nixosConfig:
    lib.optional nixosConfig.services.matrix-synapse.enable nixosConfig.services.matrix-synapse.serviceUnit
    ++ lib.optional nixosConfig.services.matrix-conduit.enable "conduit.service"
    ++ lib.optional nixosConfig.services.dendrite.enable "dendrite.service";

  defaultHomeserverSettings =
    nixosConfig:
    if nixosConfig.services.matrix-synapse.enable then
      let
        listeners =
          (nixosConfig.services.matrix-synapse.settings.listeners or [ ])
          ++ lib.concatMap (w: w.worker_listeners or [ ]) (
            lib.attrValues (nixosConfig.services.matrix-synapse.workers or { })
          );
        clientListener = lib.findFirst (
          l: (l.port or null) != null && lib.any (r: lib.elem "client" (r.names or [ ])) (l.resources or [ ])
        ) null listeners;
        scheme = if clientListener != null && (clientListener.tls or false) then "https" else "http";
        port = if clientListener != null then clientListener.port else 8008;
        bindAddresses =
          if clientListener != null && (clientListener.bind_addresses or null) != null then
            clientListener.bind_addresses
          else
            [ ];
        host =
          if lib.elem "127.0.0.1" bindAddresses || lib.elem "0.0.0.0" bindAddresses then
            "127.0.0.1"
          else if
            lib.any (
              a:
              lib.elem a [
                "::1"
                "::"
                "[::1]"
                "[::]"
              ]
            ) bindAddresses
          then
            "[::1]"
          else if bindAddresses != [ ] then
            connectHost (lib.head bindAddresses)
          else
            "127.0.0.1";
      in
      {
        domain = lib.mkDefault nixosConfig.services.matrix-synapse.settings.server_name;
        address = lib.mkDefault "${scheme}://${host}:${toString port}";
      }
    else
      lib.optionalAttrs nixosConfig.services.matrix-conduit.enable {
        domain = lib.mkDefault nixosConfig.services.matrix-conduit.settings.global.server_name;
        address = lib.mkDefault "http://${
          connectHost (nixosConfig.services.matrix-conduit.settings.global.address or "127.0.0.1")
        }:${toString nixosConfig.services.matrix-conduit.settings.global.port}";
      };

  mkBridgeOptions =
    {
      nixosConfig,
      bridgeCfg,
      name,
      serviceName ? "mautrix-${name}",
      registrationName ? name,
      secretPrefix ? lib.toUpper registrationName,
      schema ? "bridgev2",
      description,
      packageOption ? lib.mkPackageOption pkgs "mautrix-${name}" { },
      defaultDataDir ? "/var/lib/${serviceName}",
      defaultDataDirText ? lib.literalExpression ''"${defaultDataDir}"'',
      allowRelativeDataDir ? false,
      defaultSettings ? { },
      settingsDescription,
      settingsExample ? null,
      settingsDefaultText ? null,
    }:
    let
      dataDir = resolveDataDir bridgeCfg.dataDir;
      database = {
        type = "sqlite3-fk-wal";
        uri = "file:${dataDir}/mautrix-${registrationName}.db?_txlock=immediate";
      };
      appserviceHost =
        let
          host = lib.removePrefix "[" (lib.removeSuffix "]" bridgeCfg.settings.appservice.hostname);
        in
        # Dual-stack wildcards ([::]) accept IPv4 loopback, and Synapse's HTTP client
        # rejects IPv6 literal hostnames in appservice URLs.
        if
          lib.elem host [
            ""
            "0.0.0.0"
            "::"
          ]
        then
          "127.0.0.1"
        else
          formatHost host;
      baseAppservice = {
        hostname = "127.0.0.1";
        address = "http://${appserviceHost}:${toString bridgeCfg.settings.appservice.port}";
        as_token = "";
        hs_token = "";
      };
      schemaDefaults =
        if schema == "bridgev2" then
          {
            inherit database logging;
            appservice = baseAppservice;
            double_puppet = {
              servers = { };
              secrets = { };
            };
            env_config_prefix = "MAUTRIX_${secretPrefix}_";
            # Never regenerate these keys on every service start.
            encryption.pickle_key = "";
            provisioning.shared_secret = "";
            public_media.signing_key = "";
            direct_media.server_key = "";
          }
        else
          {
            inherit logging;
            appservice = baseAppservice // {
              inherit database;
            };
          };
      defaults = lib.recursiveUpdate schemaDefaults defaultSettings;
    in
    {
      enable = lib.mkEnableOption description;

      package = packageOption;

      dataDir = lib.mkOption {
        type = if allowRelativeDataDir then lib.types.str else lib.types.strMatching "/.+";
        default = defaultDataDir;
        defaultText = defaultDataDirText;
        description = ''
          Absolute path to the directory where the bridge stores its database,
          runtime configuration, and registration file.
        '';
      };

      registrationFile = lib.mkOption {
        type = lib.types.path;
        readOnly = true;
        default = "${dataDir}/${registrationName}-registration.yaml";
        defaultText = lib.literalExpression ''"''${dataDir}/${registrationName}-registration.yaml"'';
        description = "Generated application-service registration file to install on the homeserver.";
      };

      serviceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "${serviceName}.service";
        description = "Systemd bridge unit for other services to depend on.";
      };

      registrationServiceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "${serviceName}-registration.service";
        description = "Systemd unit that prepares the runtime configuration and application-service registration.";
      };

      settings = lib.mkOption (
        {
          type = format.type;
          default = { };
          apply = lib.recursiveUpdate defaults;
          description = settingsDescription;
        }
        // lib.optionalAttrs (settingsDefaultText != null) { defaultText = settingsDefaultText; }
        // lib.optionalAttrs (settingsExample != null) { example = settingsExample; }
      );

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Files containing systemd environment assignments, loaded in order
          for both registration and the bridge. Used for secret substitution:
          references such as `$VARIABLE` and `''${VARIABLE}` inside string values
          of `settings` are expanded (`$$` produces a literal `$`, and a `json::`
          prefix parses the substituted value as JSON).

          Setting `MAUTRIX_${secretPrefix}_BRIDGE_LOGIN_SHARED_SECRET` (or
          `MAUTRIX_BRIDGE_LOGIN_SHARED_SECRET` as a fallback) configures the
          double-puppeting shared secret for `settings.homeserver.domain`.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Deprecated: use `environmentFiles` instead.
          File containing systemd environment assignments for secret substitution.
        '';
      };

      serviceDependencies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = defaultDependencies nixosConfig;
        defaultText = lib.literalMD "The enabled local Matrix homeserver units.";
        description = "Systemd units to want and wait for before starting the bridge, but not registration generation.";
      };

      registerToSynapse = lib.mkOption {
        type = lib.types.bool;
        default = nixosConfig.services.matrix-synapse.enable;
        defaultText = lib.literalExpression "config.services.matrix-synapse.enable";
        description = ''
          Whether to add the bridge's application-service registration file to
          `services.matrix-synapse.settings.app_service_config_files` and order
          registration generation before Synapse starts.
        '';
      };

      rateLimited = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the application service registration should be rate-limited by the homeserver.";
      };
    };

  mkInstanceData =
    {
      nixosConfig,
      bridgeCfg,
      name,
      serviceName ? "mautrix-${name}",
      registrationName ? name,
      secretPrefix ? lib.toUpper registrationName,
      schema ? "bridgev2",
      executable ? "mautrix-${name}",
      description,
      optionPath ? "services.${serviceName}",
      extraPackages ? [ ],
      memoryDenyWriteExecute ? false,
      extraAssertions ? [ ],
      extraWarnings ? [ ],
    }:
    let
      unit = serviceName;
      registrationUnit = "${unit}-registration.service";
      dataDir = resolveDataDir bridgeCfg.dataDir;
      isUnderVarLib = lib.hasPrefix "/var/lib/" dataDir;
      settingsFile = "${dataDir}/config.yaml";
      configFile = format.generate "${unit}.json" bridgeCfg.settings;
      envFiles =
        lib.optional (bridgeCfg.environmentFile != null) bridgeCfg.environmentFile
        ++ bridgeCfg.environmentFiles;
      executablePath = lib.getExe' bridgeCfg.package executable;
      commonServiceConfig =
        sandbox
        // {
          User = unit;
          Group = unit;
          WorkingDirectory = dataDir;
          EnvironmentFile = envFiles;
        }
        // (
          if isUnderVarLib then
            {
              StateDirectory = lib.removePrefix "/var/lib/" dataDir;
              StateDirectoryMode = "0750";
            }
          else
            {
              ReadWritePaths = [ dataDir ];
            }
        );
    in
    {
      inherit unit registrationUnit;
      inherit (bridgeCfg) registrationFile;
      registerToSynapse = bridgeCfg.registerToSynapse && nixosConfig.services.matrix-synapse.enable;

      assertions = [
        {
          assertion = builtins.match "[a-zA-Z0-9_-]+" unit != null && builtins.stringLength unit <= 31;
          message = "${optionPath}: service/user name '${unit}' must be a valid system user name (at most 31 characters).";
        }
        {
          assertion =
            bridgeCfg.settings.homeserver.domain or "" != ""
            && bridgeCfg.settings.homeserver.address or "" != "";
          message = "${optionPath}.settings.homeserver.{address,domain} must be set.";
        }
        {
          assertion = bridgeCfg.settings.bridge.permissions or { } != { };
          message = "${optionPath}.settings.bridge.permissions must not be empty.";
        }
        {
          assertion =
            !(bridgeCfg.settings.public_media.enabled or false)
            || (bridgeCfg.settings.public_media.signing_key or "") != "";
          message = "${optionPath}.settings.public_media.signing_key must be configured when public_media is enabled.";
        }
        {
          assertion =
            !(bridgeCfg.settings.direct_media.enabled or false)
            || (bridgeCfg.settings.direct_media.server_key or "") != "";
          message = "${optionPath}.settings.direct_media.server_key must be configured when direct_media is enabled.";
        }
        {
          assertion = !bridgeCfg.registerToSynapse || nixosConfig.services.matrix-synapse.enable;
          message = "${optionPath}.registerToSynapse requires services.matrix-synapse.enable.";
        }
        {
          assertion =
            dataDir != ""
            && dataDir != "/var/lib"
            && !lib.hasInfix "//" dataDir
            && !lib.any (
              part:
              lib.elem part [
                "."
                ".."
              ]
            ) (lib.splitString "/" dataDir);
          message = "${optionPath}.dataDir must be a valid non-root directory path without '.', '..', or empty path segments.";
        }
      ]
      ++ extraAssertions;

      warnings =
        lib.optional (
          bridgeCfg.environmentFile != null
        ) "${optionPath}.environmentFile is deprecated; use ${optionPath}.environmentFiles instead."
        ++
          lib.optional (!lib.hasPrefix "/" bridgeCfg.dataDir)
            "${optionPath}.dataDir should be an absolute path (e.g. \"/var/lib/${bridgeCfg.dataDir}\"); relative paths are deprecated."
        ++ extraWarnings;

      user = {
        ${unit} = {
          isSystemUser = true;
          group = unit;
          home = dataDir;
          description = "${description} user";
        };
      };

      group = {
        ${unit} = { };
      };

      tmpfilesRules = lib.optional (!isUnderVarLib) "d ${dataDir} 0750 ${unit} ${unit} -";

      services = {
        "${unit}-registration" = {
          description = "Prepare ${description} configuration and registration";
          restartTriggers = [ configFile ];
          serviceConfig = commonServiceConfig // {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = lib.escapeShellArgs [
              (lib.getExe generateRegistration)
              configFile
              (toString bridgeCfg.registrationFile)
              executablePath
              schema
              secretPrefix
              (lib.boolToString bridgeCfg.rateLimited)
            ];
          };
        };

        ${unit} = {
          inherit description;
          wantedBy = [ "multi-user.target" ];
          requires = [ registrationUnit ];
          wants = [
            "network-online.target"
          ]
          ++ bridgeCfg.serviceDependencies;
          after = [
            "network-online.target"
            registrationUnit
          ]
          ++ bridgeCfg.serviceDependencies;
          path = [
            pkgs.ffmpeg-headless
          ]
          ++ extraPackages;
          environment.HOME = dataDir;
          restartTriggers = [ configFile ];
          serviceConfig = commonServiceConfig // {
            Type = "simple";
            PrivateUsers = true;
            MemoryDenyWriteExecute = lib.mkIf memoryDenyWriteExecute true;
            Restart = "on-failure";
            RestartSec = "30s";
            ExecStart = lib.escapeShellArgs [
              executablePath
              "--config=${settingsFile}"
            ];
          };
        };
      };
    };

  mkBridgesConfig =
    instances:
    let
      built = map mkInstanceData instances;
      registered = lib.filter (b: b.registerToSynapse) built;
    in
    {
      assertions = lib.concatMap (b: b.assertions) built;
      warnings = lib.concatMap (b: b.warnings) built;
      users.users =
        lib.foldl' (acc: b: acc // b.user) { } built
        // lib.optionalAttrs (registered != [ ]) {
          matrix-synapse.extraGroups = map (b: b.unit) registered;
        };
      users.groups = lib.foldl' (acc: b: acc // b.group) { } built;
      systemd.tmpfiles.rules = lib.concatMap (b: b.tmpfilesRules) built;
      services.matrix-synapse = lib.mkIf (registered != [ ]) {
        settings.app_service_config_files = map (b: b.registrationFile) registered;
      };
      systemd.services = lib.mkMerge (
        [
          {
            # Workers require the main process, so this also orders worker startup.
            matrix-synapse = lib.mkIf (registered != [ ]) {
              wants = map (b: b.registrationUnit) registered;
              after = map (b: b.registrationUnit) registered;
            };
          }
        ]
        ++ map (b: b.services) built
      );
    };

  mkBridge =
    {
      nixosConfig,
      name,
      serviceName ? "mautrix-${name}",
      registrationName ? name,
      secretPrefix ? lib.toUpper registrationName,
      schema ? "bridgev2",
      executable ? "mautrix-${name}",
      description,
      packageOption ? lib.mkPackageOption pkgs "mautrix-${name}" { },
      defaultDataDir ? "/var/lib/${serviceName}",
      defaultDataDirText ? lib.literalExpression ''"${defaultDataDir}"'',
      allowRelativeDataDir ? false,
      defaultSettings ? { },
      settingsDescription,
      settingsExample ? null,
      settingsDefaultText ? null,
      extraPackages ? [ ],
      memoryDenyWriteExecute ? false,
      extraAssertions ? [ ],
      extraWarnings ? [ ],
      meta,
    }:
    let
      bridgeCfg = nixosConfig.services.${serviceName};
    in
    {
      options.services.${serviceName} = mkBridgeOptions {
        inherit
          nixosConfig
          bridgeCfg
          name
          serviceName
          registrationName
          secretPrefix
          schema
          description
          packageOption
          defaultDataDir
          defaultDataDirText
          allowRelativeDataDir
          defaultSettings
          settingsDescription
          settingsExample
          settingsDefaultText
          ;
      };

      config = lib.mkIf bridgeCfg.enable (
        lib.mkMerge [
          {
            services.${serviceName}.settings.homeserver = defaultHomeserverSettings nixosConfig;
          }
          (mkBridgesConfig [
            {
              inherit
                nixosConfig
                bridgeCfg
                name
                serviceName
                registrationName
                secretPrefix
                schema
                executable
                description
                extraPackages
                memoryDenyWriteExecute
                extraAssertions
                extraWarnings
                ;
            }
          ])
        ]
      );

      inherit meta;
    };
in
{
  inherit
    defaultDependencies
    defaultHomeserverSettings
    format
    logging
    mkBridge
    mkBridgesConfig
    mkBridgeOptions
    resolveDataDir
    ;
}
