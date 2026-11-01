{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mautrix;
  nixosConfig = config;
  profiles = import ./mautrix-profiles.nix { inherit lib pkgs; };
  format = pkgs.formats.json { };
  enabled = lib.filterAttrs (_: bridge: bridge.enable) cfg.bridges;
  registered = lib.filterAttrs (_: bridge: bridge.registerToSynapse) enabled;
  serviceName = name: "mautrix-${name}";
  settingsFile = bridge: "${bridge.dataDir}/config.yaml";
  configFile = name: bridge: format.generate "mautrix-${name}.json" bridge.settings;
  registrationUnit = name: "${serviceName name}-registration.service";
  dependencies =
    lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit
    ++ lib.optional config.services.matrix-conduit.enable "conduit.service"
    ++ lib.optional config.services.dendrite.enable "dendrite.service";
  registrationUnits = lib.mapAttrsToList (name: _: registrationUnit name) registered;
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
  substituteConfig = pkgs.writers.writePython3Bin "mautrix-substitute-config" { } ''
    import json
    import os
    import re
    import sys

    VAR_RE = re.compile(
        r"\$\$|\$([A-Za-z_][A-Za-z0-9_]*)|(?:\$\{([A-Za-z_][A-Za-z0-9_]*)\})"
    )


    def sub(m):
        if m.group(0) == "$$":
            return "$"
        var = m.group(1) or m.group(2)
        if var not in os.environ:
            sys.exit(
                f"Error: environment variable '{var}' referenced in "
                "configuration is not set"
            )
        return os.environ[var]


    def walk(n):
        if isinstance(n, dict):
            return {k: walk(v) for k, v in n.items()}
        if isinstance(n, list):
            return [walk(v) for v in n]
        if isinstance(n, str):
            res = VAR_RE.sub(sub, n)
            if res.startswith("json::"):
                return json.loads(res[6:])
            return res
        return n


    with open(sys.argv[1]) as f:
        data = json.load(f)

    with open(sys.argv[2], "w") as f:
        json.dump(walk(data), f)
  '';
in
{
  options.services.mautrix.bridges = lib.mkOption {
    default = { };
    description = ''
      Mautrix bridge instances. Each instance has a separate system user,
      systemd service, state directory, and application-service registration.
      The instance name determines the user and service name, `mautrix-<name>`.
      Upstream configuration schemas still differ between bridge implementations.
    '';
    example = lib.literalExpression ''
      {
        signal = {
          type = "signal";
          environmentFiles = [ "/run/secrets/matrix-bridge.env" ];
          settings = {
            homeserver.address = "http://localhost:8008";
            homeserver.domain = "example.com";
            bridge.permissions."@admin:example.com" = "admin";
            double_puppet.secrets."example.com" = "as_token:$SHARED_AS_TOKEN";
          };
        };
      }
    '';
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, config, ... }:
        let
          bridge = config;
          profile = profiles.${bridge.type};
          database = {
            type = "sqlite3-fk-wal";
            uri = "file:${bridge.dataDir}/mautrix-${profile.registrationName}.db?_txlock=immediate";
          };
          defaults = lib.recursiveUpdate (
            {
              appservice = {
                hostname = "localhost";
                address = "http://${
                  if profile.useAppserviceHostnameForAddress or false then
                    bridge.settings.appservice.hostname
                  else
                    "localhost"
                }:${toString bridge.settings.appservice.port}";
                as_token = "";
                hs_token = "";
              };
            }
            // (
              if profile.schema == "bridgev2" then
                {
                  inherit database;
                  env_config_prefix = "MAUTRIX_${profile.secretPrefix or (lib.toUpper profile.registrationName)}_";
                  # Never regenerate these keys on every service start.
                  encryption.pickle_key = "";
                  provisioning.shared_secret = "";
                  public_media.signing_key = "";
                  direct_media.server_key = "";
                }
              else
                {
                  appservice = {
                    hostname = "localhost";
                    address = "http://localhost:${toString bridge.settings.appservice.port}";
                    as_token = "";
                    hs_token = "";
                    inherit database;
                  };
                }
            )
          ) profile.settings;
        in
        {
          options = {
            enable = lib.mkEnableOption "this Mautrix bridge instance" // {
              default = true;
            };
            type = lib.mkOption {
              type = lib.types.enum (builtins.attrNames profiles);
              example = "signal";
              description = "Bridge network and default package/configuration profile.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              default = profile.package;
              defaultText = lib.literalMD "The package for the selected bridge type.";
              description = "Bridge package to run.";
            };
            dataDir = lib.mkOption {
              type = lib.types.strMatching "/var/lib/[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*";
              default = "/var/lib/${serviceName name}";
              defaultText = lib.literalExpression ''"/var/lib/mautrix-''${name}"'';
              description = "Absolute state directory beneath /var/lib. Preserve this path when migrating an existing bridge.";
            };
            registrationFile = lib.mkOption {
              type = lib.types.path;
              readOnly = true;
              default = "${bridge.dataDir}/${profile.registrationName}-registration.yaml";
              defaultText = lib.literalExpression ''"''${dataDir}/<network>-registration.yaml"'';
              description = "Generated application-service registration file to install on the homeserver.";
            };
            serviceUnit = lib.mkOption {
              type = lib.types.str;
              readOnly = true;
              default = "${serviceName name}.service";
              defaultText = lib.literalExpression ''"mautrix-''${name}.service"'';
              description = "Systemd bridge unit for other services to depend on.";
            };
            registrationServiceUnit = lib.mkOption {
              type = lib.types.str;
              readOnly = true;
              default = registrationUnit name;
              defaultText = lib.literalExpression ''"mautrix-''${name}-registration.service"'';
              description = "Systemd unit that prepares the runtime configuration and application-service registration.";
            };
            settings = lib.mkOption {
              type = format.type;
              default = { };
              apply = lib.recursiveUpdate defaults;
              description = ''
                Upstream bridge configuration. Network-specific defaults are supplied
                by the selected type; consult the package's example configuration.
                Secrets must not be written here: use `$VARIABLE` or
                `''${VARIABLE}` references supplied through `environmentFiles`.
                Set bridgev2 encryption and signing keys explicitly; `generate`
                would otherwise generate a different key after each restart.
              '';
            };
            environmentFiles = lib.mkOption {
              type = lib.types.listOf lib.types.path;
              default = [ ];
              description = ''
                Files containing systemd environment assignments, loaded in order
                for both registration and the bridge. Used for secret substitution.
                `MAUTRIX_BRIDGE_LOGIN_SHARED_SECRET` sets the double-puppeting
                secret for `settings.homeserver.domain`, using the appropriate
                configuration key for each bridge schema. Existing network-specific
                `MAUTRIX_<NETWORK>_BRIDGE_LOGIN_SHARED_SECRET` names also work.
              '';
            };
            serviceDependencies = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = dependencies;
              defaultText = lib.literalMD "The enabled local Matrix homeserver units.";
              description = "Systemd units to want and wait for before starting the bridge, but not registration generation.";
            };
            registerToSynapse = lib.mkOption {
              type = lib.types.bool;
              default = nixosConfig.services.matrix-synapse.enable;
              defaultText = lib.literalExpression "config.services.matrix-synapse.enable";
              description = "Register with the local Synapse and generate registration before Synapse starts.";
            };
            rateLimited = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether the application service registration should be rate-limited by the homeserver.";
            };
          };
          config.settings.homeserver =
            if nixosConfig.services.matrix-synapse.enable then
              let
                listeners = nixosConfig.services.matrix-synapse.settings.listeners or [ ];
                clientListener = lib.findFirst (
                  l: lib.elem "client" (l.resources or [ ] ++ lib.concatMap (r: r.names or [ ]) (l.tls or [ ]))
                ) null listeners;
                port = if clientListener != null then clientListener.port else 8008;
              in
              {
                domain = lib.mkDefault nixosConfig.services.matrix-synapse.settings.server_name;
                address = lib.mkDefault "http://localhost:${toString port}";
              }
            else
              lib.optionalAttrs nixosConfig.services.matrix-conduit.enable {
                domain = lib.mkDefault nixosConfig.services.matrix-conduit.settings.global.server_name;
                address = lib.mkDefault "http://localhost:${toString nixosConfig.services.matrix-conduit.settings.global.port}";
              };
        }
      )
    );
  };

  config = lib.mkIf (enabled != { }) {
    assertions =
      lib.concatLists (
        lib.mapAttrsToList (
          name: bridge:
          let
            profile = profiles.${bridge.type};
          in
          [
            {
              assertion =
                builtins.match "[a-zA-Z0-9_-]+" name != null && builtins.stringLength (serviceName name) <= 31;
              message = "services.mautrix.bridges instance names must form a valid system user name (mautrix-<name>, at most 31 characters).";
            }
            {
              assertion =
                bridge.settings.homeserver.domain or "" != "" && bridge.settings.homeserver.address or "" != "";
              message = "services.mautrix.bridges.${name}.settings.homeserver.{address,domain} must be set.";
            }
            {
              assertion = bridge.settings.bridge.permissions or { } != { };
              message = "services.mautrix.bridges.${name}.settings.bridge.permissions must not be empty.";
            }
            {
              assertion =
                !(bridge.settings.public_media.enabled or false)
                || (bridge.settings.public_media.signing_key or "") != "";
              message = "services.mautrix.bridges.${name}.settings.public_media.signing_key must be configured when public_media is enabled.";
            }
            {
              assertion =
                !(bridge.settings.direct_media.enabled or false)
                || (bridge.settings.direct_media.server_key or "") != "";
              message = "services.mautrix.bridges.${name}.settings.direct_media.server_key must be configured when direct_media is enabled.";
            }
            {
              assertion = !bridge.registerToSynapse || config.services.matrix-synapse.enable;
              message = "services.mautrix.bridges.${name}.registerToSynapse requires services.matrix-synapse.enable.";
            }
            {
              assertion =
                !lib.any (
                  part:
                  lib.elem part [
                    "."
                    ".."
                  ]
                ) (lib.splitString "/" bridge.dataDir);
              message = "services.mautrix.bridges.${name}.dataDir must not contain '.' or '..' components.";
            }
          ]
          ++ (profile.assertions or (_: _: [ ])) name bridge
        ) enabled
      )
      ++ [
        {
          assertion =
            lib.length (lib.unique (lib.mapAttrsToList (_: bridge: bridge.dataDir) enabled))
            == lib.length (builtins.attrNames enabled);
          message = "services.mautrix.bridges instances must have separate data directories.";
        }
      ];

    users.users =
      lib.mapAttrs' (
        name: bridge:
        lib.nameValuePair (serviceName name) {
          isSystemUser = true;
          group = serviceName name;
          home = bridge.dataDir;
          description = "Mautrix bridge ${name}";
        }
      ) enabled
      // lib.optionalAttrs (registered != { }) {
        matrix-synapse.extraGroups = lib.mapAttrsToList (name: _: serviceName name) registered;
      };
    users.groups = lib.mapAttrs' (name: _: lib.nameValuePair (serviceName name) { }) enabled;

    services.matrix-synapse.settings.app_service_config_files = lib.mapAttrsToList (
      _: bridge: bridge.registrationFile
    ) registered;

    systemd.services = lib.mkMerge (
      [
        {
          # Workers require the main process, so this also orders worker startup.
          matrix-synapse = lib.mkIf (registered != { }) {
            wants = registrationUnits;
            after = registrationUnits;
          };
        }
      ]
      ++ lib.mapAttrsToList (
        name: bridge:
        let
          unit = serviceName name;
          profile = profiles.${bridge.type};
          executable = lib.getExe' bridge.package profile.executable;
          common = sandbox // {
            User = unit;
            Group = unit;
            StateDirectory = lib.removePrefix "/var/lib/" bridge.dataDir;
            StateDirectoryMode = "0750";
            WorkingDirectory = bridge.dataDir;
            EnvironmentFile = bridge.environmentFiles;
          };
        in
        {
          "${unit}-registration" = {
            description = "Prepare Mautrix bridge ${name} and its registration";
            restartTriggers = [ (configFile name bridge) ];
            serviceConfig = common // {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              umask 0077
              rm -f config.yaml
              ${lib.getExe substituteConfig} ${configFile name bridge} config.yaml

              # Keep the common secret interface independent of the upstream schema.
              ${pkgs.yq}/bin/yq -Y \
                --arg schema ${lib.escapeShellArg profile.schema} \
                --arg prefix ${
                  lib.escapeShellArg (profile.secretPrefix or (lib.toUpper profile.registrationName))
                } '
                (env.MAUTRIX_BRIDGE_LOGIN_SHARED_SECRET // env["MAUTRIX_" + $prefix + "_BRIDGE_LOGIN_SHARED_SECRET"]) as $secret
                | if $secret == null then .
                  elif $schema == "bridgev2" then .double_puppet.secrets[.homeserver.domain] = $secret
                  else .bridge.login_shared_secret_map[.homeserver.domain] = $secret end
              ' config.yaml > config.yaml.tmp
              mv config.yaml.tmp config.yaml

              # Explicit tokens take precedence; otherwise retain the existing registration.
              if [ -f ${lib.escapeShellArg (toString bridge.registrationFile)} ]; then
                cp ${lib.escapeShellArg (toString bridge.registrationFile)} registration.yaml.old
                ${pkgs.yq}/bin/yq -sY '
                  def configured: . != null and . != "" and . != "generate"
                    and . != "This value is generated when generating the registration";
                  .[1] as $registration | .[0]
                  | if (.appservice.as_token | configured) then . else .appservice.as_token = $registration.as_token end
                  | if (.appservice.hs_token | configured) then . else .appservice.hs_token = $registration.hs_token end
                ' config.yaml registration.yaml.old > config.yaml.tmp
                mv config.yaml.tmp config.yaml
              else
                echo "{}" > registration.yaml.old
              fi

              # Registration generation may rewrite the input and rotate its tokens.
              cp config.yaml config-registration.yaml
              ${lib.escapeShellArg executable} --generate-registration \
                --config=config-registration.yaml --registration=registration.yaml.new
              ${pkgs.yq}/bin/yq -sY \
                --argjson rate_limited ${lib.boolToString bridge.rateLimited} '
                def configured: . != null and . != "" and . != "generate"
                  and . != "This value is generated when generating the registration";
                .[0] as $config | .[1] as $new_reg | .[2] as $old_reg | $new_reg
                | if ($config.appservice.as_token | configured) then .as_token = $config.appservice.as_token else . end
                | if ($config.appservice.hs_token | configured) then .hs_token = $config.appservice.hs_token else . end
                | if ($old_reg | type == "object" and has("sender_localpart")) then .sender_localpart = $old_reg.sender_localpart else . end
                | .rate_limited = $rate_limited
              ' config.yaml registration.yaml.new registration.yaml.old > registration.yaml.tmp
              chmod 640 registration.yaml.tmp
              mv registration.yaml.tmp ${lib.escapeShellArg (toString bridge.registrationFile)}
              ${pkgs.yq}/bin/yq -sY '
                .[0].appservice.as_token = .[1].as_token
                | .[0].appservice.hs_token = .[1].hs_token | .[0]
              ' config.yaml ${lib.escapeShellArg (toString bridge.registrationFile)} > config.yaml.tmp
              mv config.yaml.tmp config.yaml
              rm config-registration.yaml
              rm registration.yaml.new
              rm registration.yaml.old
            '';
          };
          ${unit} = {
            description = "Mautrix ${bridge.type} bridge (${name})";
            wantedBy = [ "multi-user.target" ];
            requires = [ (registrationUnit name) ];
            wants = [
              "network-online.target"
            ]
            ++ bridge.serviceDependencies;
            after = [
              "network-online.target"
              (registrationUnit name)
            ]
            ++ bridge.serviceDependencies;
            path = [
              pkgs.ffmpeg-headless
            ]
            ++ (profile.extraPackages or [ ]);
            environment.HOME = bridge.dataDir;
            restartTriggers = [ (configFile name bridge) ];
            serviceConfig = common // {
              Type = "simple";
              PrivateUsers = true;
              MemoryDenyWriteExecute = lib.mkIf (profile.memoryDenyWriteExecute or false) true;
              Restart = "on-failure";
              RestartSec = "30s";
              WorkingDirectory = bridge.dataDir;
              ExecStart = lib.escapeShellArgs [
                executable
                "--config=${settingsFile bridge}"
              ];
            };
          };
        }
      ) enabled
    );
  };

  meta = {
    doc = ./mautrix.md;
    maintainers = with lib.maintainers; [
      euxane
      vskilet
      pentane
      frederictobiasc
      mistyttm
    ];
  };
}
