{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    concatMapStringsSep
    concatStringsSep
    escapeRegex
    escapeShellArg
    genAttrs
    getExe
    getExe'
    getName
    literalExpression
    mapAttrs
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    optionals
    types
    ;
  inherit (lib.strings) sanitizeDerivationName;

  cfg = config.services.portmaster;
  settingsFormat = pkgs.formats.json { };

  nonEmptyStringType = types.addCheck types.str (value: value != "");
  relativeDirectoryType = types.addCheck types.str (
    value:
    value == ""
    || (
      !(lib.hasPrefix "/" value)
      && !(lib.hasSuffix "/" value)
      && builtins.all (
        component:
        !builtins.elem component [
          ""
          "."
          ".."
        ]
      ) (lib.splitString "/" value)
    )
  );

  fingerprintType = types.submodule {
    options = {
      type = mkOption {
        type = types.enum [
          "path"
          "cmdline"
          "env"
          "tag"
        ];
        description = "Portmaster fingerprint type.";
      };
      key = mkOption {
        type = types.nullOr nonEmptyStringType;
        default = null;
        description = ''
          Environment variable or metadata tag key. Required for `env` and
          `tag` fingerprints, and invalid for `path` and `cmdline` fingerprints.
        '';
      };
      operation = mkOption {
        type = types.enum [
          "equals"
          "prefix"
          "regex"
        ];
        description = "Operation used to compare the fingerprint value.";
      };
      value = mkOption {
        type = nonEmptyStringType;
        description = "The value to match against.";
      };
    };
  };

  packageMatchType = types.submodule (
    { config, ... }:
    {
      options = {
        package = mkOption {
          type = types.package;
          description = "Package from which to derive a Portmaster fingerprint.";
        };

        type = mkOption {
          type = types.enum [
            "path"
            "cmdline"
          ];
          default = "path";
          description = "Fingerprint type used for the generated package regular expression.";
        };

        storeNameRegex = mkOption {
          type = types.nullOr nonEmptyStringType;
          default = null;
          example = "python3[0-9.]*-umu-launcher-unwrapped-[0-9.]+";
          description = ''
            Regular expression matching the package output name after the Nix
            store hash. `null` matches the package's `pname` with an optional
            version suffix.
          '';
        };

        directory = mkOption {
          type = relativeDirectoryType;
          default = "bin";
          example = "share/go/bin";
          description = ''
            Relative directory below the package output that contains the
            executable. An empty string selects the output root.
          '';
        };

        name = mkOption {
          type = types.nullOr nonEmptyStringType;
          default = config.package.meta.mainProgram or (config.package.pname or (getName config.package));
          defaultText = literalExpression "package.meta.mainProgram or package.pname";
          example = "nmap";
          description = ''
            Executable name. Set this to `null` and disable `strictLast` to
            match every path below `directory`.
          '';
        };

        wrapped = mkOption {
          type = types.bool;
          default = true;
          description = "Also match Nix wrapper names such as `.program-wrapped`.";
        };

        strictHead = mkOption {
          type = types.bool;
          default = true;
          description = "Anchor the generated regular expression at the beginning.";
        };

        strictLast = mkOption {
          type = types.bool;
          default = true;
          description = "Anchor the generated regular expression at the end.";
        };
      };
    }
  );

  profilePackageType = types.coercedTo types.package (package: { inherit package; }) packageMatchType;

  normalizeFingerprint =
    fingerprint:
    {
      inherit (fingerprint) type operation;
      # Keep string context so manually specified package paths remain in the
      # system closure.
      value = toString fingerprint.value;
    }
    // optionalAttrs ((fingerprint.key or null) != null) {
      inherit (fingerprint) key;
    };

  fingerprintIdentityKey =
    fingerprint: builtins.unsafeDiscardStringContext (builtins.toJSON fingerprint);

  normalizeFingerprints =
    fingerprints:
    mapAttrsToList (
      _: fingerprintsWithSameIdentity:
      let
        fingerprint = builtins.head fingerprintsWithSameIdentity;
      in
      fingerprint
      // {
        value = builtins.foldl' (
          value: duplicate: lib.addContextFrom duplicate.value value
        ) fingerprint.value (builtins.tail fingerprintsWithSameIdentity);
      }
    ) (builtins.groupBy fingerprintIdentityKey (map normalizeFingerprint fingerprints));

  mkPackageRegex =
    packageMatch:
    let
      packageName = packageMatch.package.pname or (getName packageMatch.package);
      storeNameRegex =
        if packageMatch.storeNameRegex == null then
          "${escapeRegex packageName}(-[^/]+)?"
        else
          packageMatch.storeNameRegex;
      inherit (packageMatch) name;
    in
    concatStringsSep "" [
      (lib.optionalString packageMatch.strictHead "^")
      (escapeRegex builtins.storeDir)
      "/[a-z0-9]{32}-"
      storeNameRegex
      (lib.optionalString (packageMatch.directory != "") "/${escapeRegex packageMatch.directory}")
      "/"
      (
        if name == null then
          ""
        else if packageMatch.wrapped then
          "(${escapeRegex name}|\\.${escapeRegex name}-wrapped)"
        else
          escapeRegex name
      )
      (lib.optionalString packageMatch.strictLast "$")
    ];

  mkPackageFingerprint = packageMatch: {
    inherit (packageMatch) type;
    operation = "regex";
    value = mkPackageRegex packageMatch;
  };

  fingerprintError =
    fingerprint:
    if
      builtins.elem fingerprint.type [
        "env"
        "tag"
      ]
      && (fingerprint.key or null) == null
    then
      "`${fingerprint.type}` fingerprints require `key`"
    else if
      builtins.elem fingerprint.type [
        "path"
        "cmdline"
      ]
      && (fingerprint.key or null) != null
    then
      "`${fingerprint.type}` fingerprints must not set `key`"
    else
      null;

  stateDir = toString cfg.stateDir;
  logsDir = "${stateDir}/logs";
  configDir = "${stateDir}/config";
  packageLibDir = "${cfg.package}/lib/portmaster";

  runtimeConfigPath = "${stateDir}/config.json";
  runtimeConfigManagedMarkerPath = "${stateDir}/.config.json.nix-managed";
  profilesApiKeyPath = "${configDir}/nix-managed-profiles-api-key";

  profilesApiBaseUrl = "http://127.0.0.1:817/api/v1";
  profilesPingUrl = "${profilesApiBaseUrl}/ping";
  profilesImportUrl = "${profilesApiBaseUrl}/sync/profile/import?allowReplace";

  configSettings = builtins.removeAttrs cfg.settings [ "devmode" ];
  hasExternalConfigInputs = cfg.settingsFile != null || cfg.secretsFile != null;
  profilesEnabled = cfg.profiles != { };
  shouldGenerateManagedConfig = configSettings != { } || hasExternalConfigInputs || profilesEnabled;

  managedConfigSettings =
    optionalAttrs (shouldGenerateManagedConfig && !builtins.hasAttr "core/devMode" cfg.settings) {
      "core/devMode" = cfg.settings.devmode;
    }
    // configSettings;
  generatedManagedConfigFile = settingsFormat.generate "portmaster-config.json" managedConfigSettings;
  managedConfigMergeInputs =
    optionals shouldGenerateManagedConfig [ generatedManagedConfigFile ]
    ++ optional (cfg.settingsFile != null) cfg.settingsFile
    ++ optional (cfg.secretsFile != null) cfg.secretsFile;
  managesConfig = managedConfigMergeInputs != [ ];

  portmasterCapabilities = [
    "cap_chown"
    "cap_kill"
    "cap_net_admin"
    "cap_net_bind_service"
    "cap_net_broadcast"
    "cap_net_raw"
    "cap_sys_module"
    "cap_sys_ptrace"
    "cap_dac_override"
    "cap_fowner"
    "cap_fsetid"
    "cap_sys_resource"
    "cap_bpf"
    "cap_perfmon"
  ];

  tmpfileDir = {
    mode = "0755";
    user = "root";
    group = "root";
  };

  tmpfileDirectories = [
    stateDir
    logsDir
    configDir
  ];

  mkProfileResolution =
    logicalName: profileCfg:
    let
      rawFingerprints = map mkPackageFingerprint profileCfg.packages ++ profileCfg.fingerprints;
      fingerprints = normalizeFingerprints rawFingerprints;
      packageErrors = builtins.filter (error: error != null) (
        map (
          packageMatch:
          if packageMatch.name == null && packageMatch.strictLast then
            "`strictLast` must be false when a package match has no executable `name`"
          else
            null
        ) profileCfg.packages
      );
      fingerprintErrors = builtins.filter (error: error != null) (map fingerprintError fingerprints);
      error =
        if rawFingerprints == [ ] then
          "one of `packages` or `fingerprints` must be non-empty"
        else if packageErrors != [ ] then
          builtins.head packageErrors
        else if fingerprintErrors != [ ] then
          builtins.head fingerprintErrors
        else
          null;
    in
    {
      inherit logicalName error fingerprints;
      inherit (profileCfg) settings;
      name = cfg.profilePrefix + profileCfg.name;
    };

  profileResolutions = mapAttrs mkProfileResolution cfg.profiles;
  profileErrors = builtins.filter (error: error != null) (
    mapAttrsToList (
      logicalName: resolution:
      if resolution.error != null then "`${logicalName}`: ${resolution.error}" else null
    ) profileResolutions
  );

  mkProfilePayload = profileCfg: {
    type = "profile";
    source = "local";
    inherit (profileCfg) name;
    inherit (profileCfg) fingerprints;
    config = profileCfg.settings;
  };

  profileIdentityEntries = builtins.filter (entry: entry != null) (
    mapAttrsToList (
      logicalName: resolution:
      if resolution.error == null then
        {
          inherit logicalName;
          normalizedFingerprints = resolution.fingerprints;
          identityKey = fingerprintIdentityKey resolution.fingerprints;
        }
      else
        null
    ) profileResolutions
  );

  profileIdentityCollisions = builtins.filter (group: builtins.length group > 1) (
    builtins.attrValues (builtins.groupBy (entry: entry.identityKey) profileIdentityEntries)
  );

  formatProfileIdentityCollision =
    group:
    let
      profileNames = map (entry: "`${entry.logicalName}`") group;
      inherit ((builtins.head group)) normalizedFingerprints;
    in
    "profiles ${concatStringsSep ", " profileNames} normalize to the same fingerprints: ${builtins.toJSON normalizedFingerprints}";

  profileExports = mapAttrsToList (logicalName: resolution: {
    inherit logicalName;
    path = settingsFormat.generate "portmaster-profile-${sanitizeDerivationName logicalName}.json" (
      mkProfilePayload resolution
    );
  }) profileResolutions;

  mergeConfig = pkgs.writeShellScript "portmaster-merge-config" ''
    set -euo pipefail

    umask 077
    key_tmp=
    cleanup() {
      ${getExe' pkgs.coreutils "rm"} -f \
        ${escapeShellArg runtimeConfigPath}.tmp \
        "''${key_tmp:-}"
    }
    trap cleanup EXIT

    inputs=(
    ${concatMapStringsSep "\n" (input: "  ${escapeShellArg (toString input)}") managedConfigMergeInputs}
    )

    ${lib.optionalString profilesEnabled ''
      if [ ! -s ${escapeShellArg profilesApiKeyPath} ]; then
        key_tmp="$(${getExe' pkgs.coreutils "mktemp"} ${escapeShellArg "${configDir}/.nix-managed-profiles-api-key.XXXXXX"})"
        ${getExe' pkgs.coreutils "od"} -An -tx1 -N32 /dev/urandom | ${getExe' pkgs.coreutils "tr"} -d ' \n' > "$key_tmp"
        if [ "$(${getExe' pkgs.coreutils "wc"} -c < "$key_tmp")" -ne 64 ]; then
          printf >&2 '%s\n' "Failed to generate Portmaster managed profiles API key"
          exit 1
        fi
        ${getExe' pkgs.coreutils "install"} -m 0600 -o root -g root "$key_tmp" ${escapeShellArg profilesApiKeyPath}
        ${getExe' pkgs.coreutils "rm"} -f "$key_tmp"
        key_tmp=
      fi

      managed_api_key="$(${getExe' pkgs.coreutils "tr"} -d '\r\n' < ${escapeShellArg profilesApiKeyPath})"
      if [[ ! "$managed_api_key" =~ ^[0-9a-f]{64}$ ]]; then
        printf >&2 '%s\n' "Portmaster managed profiles API key must contain exactly 64 lowercase hexadecimal characters"
        exit 1
      fi
      unset managed_api_key

      ${getExe' pkgs.coreutils "chown"} root:root ${escapeShellArg profilesApiKeyPath}
      ${getExe' pkgs.coreutils "chmod"} 0600 ${escapeShellArg profilesApiKeyPath}
    ''}

    if [ "''${#inputs[@]}" -eq 0 ]; then
      exit 0
    fi

    for input in "''${inputs[@]}"; do
      if ! ${getExe pkgs.jq} -e '
        if type == "object" then
          if has("core/apiKeys") and (."core/apiKeys" | type != "array") then
            error("core/apiKeys must be an array")
          else
            true
          end
        else
          error("top-level JSON value must be an object")
        end
      ' "$input" > /dev/null; then
        printf >&2 'Invalid Portmaster config input: %s\n' "$input"
        exit 1
      fi
    done

    jq_merge_args=(-s)
    ${lib.optionalString profilesEnabled ''
      jq_merge_args+=(--rawfile profilesApiKey ${escapeShellArg profilesApiKeyPath})
    ''}

    ${getExe pkgs.jq} "''${jq_merge_args[@]}" '
      reduce .[] as $item ({}; . * $item)
      ${lib.optionalString profilesEnabled ''
          | if has("core/apiKeys") and (."core/apiKeys" | type != "array") then
              error("core/apiKeys must be an array")
            else
              .
            end
        | (."core/apiKeys" // []) as $apiKeys
        | (($profilesApiKey | gsub("[\\r\\n]"; "")) + "?read=admin&write=admin") as $managedApiKey
          | ."core/apiKeys" = (
              $apiKeys + (if ($apiKeys | index($managedApiKey)) then [] else [ $managedApiKey ] end)
            )
      ''}
    ' "''${inputs[@]}" > ${escapeShellArg runtimeConfigPath}.tmp
    ${getExe' pkgs.coreutils "install"} -m 0600 ${escapeShellArg runtimeConfigPath}.tmp ${escapeShellArg runtimeConfigPath}
    : > ${escapeShellArg runtimeConfigManagedMarkerPath}
    ${getExe' pkgs.coreutils "chmod"} 0600 ${escapeShellArg runtimeConfigManagedMarkerPath}
  '';
in
{
  options.services.portmaster = {
    enable = mkEnableOption "Portmaster application firewall";

    package = mkPackageOption pkgs "portmaster" { };

    stateDir = mkOption {
      type = types.externalPath;
      default = "/var/lib/portmaster";
      example = "/persist/portmaster";
      description = "Directory used for Portmaster's mutable state, configuration, and logs.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options.devmode = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable development mode, which relaxes local API authentication
            for debugging and browser access to 127.0.0.1:817. The packaged
            desktop client does not require this option.
          '';
        };
      };
      default = { };
      example = {
        "core/log/level" = "warning";
      };
      description = ''
        Global Portmaster settings for runtime {file}`config.json`.
        Per-application profiles are managed by {option}`profiles`.

        Merge order is recursive and later inputs win: this option,
        {option}`settingsFile`, then {option}`secretsFile`.

        When declarative configuration is active, the module owns runtime
        {file}`config.json`; global changes made only through the UI are not
        preserved across service starts.

        Do not put secrets here; values are stored in the Nix store. Use
        {option}`secretsFile` instead.

        Upstream currently documents the available keys in
        [basic_config.go](https://github.com/safing/portmaster/blob/v2.2.1/base/config/basic_config.go#L10-L96).
      '';
    };

    settingsFile = mkOption {
      type = types.nullOr types.externalPath;
      default = null;
      example = "/run/secrets/portmaster-settings.json";
      description = ''
        Additional global settings JSON file merged after {option}`settings`.
        Overlapping keys override values from that option.
      '';
    };

    secretsFile = mkOption {
      type = types.nullOr types.externalPath;
      default = null;
      example = "/run/secrets/portmaster-secrets.json";
      description = ''
        Sensitive global settings JSON file merged last into runtime
        {file}`config.json`, keeping secret values out of the Nix store.
      '';
    };

    profilePrefix = mkOption {
      type = types.str;
      default = "";
      example = "[NixOS] ";
      description = "Prefix added to the display name of every declarative profile.";
    };

    profiles = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = nonEmptyStringType;
                default = name;
                description = "Human-readable Portmaster profile name.";
              };

              packages = mkOption {
                type = types.listOf profilePackageType;
                default = [ ];
                example = literalExpression ''
                  [
                    pkgs.firefox
                    {
                      package = pkgs.go;
                      directory = "share/go/bin";
                    }
                  ]
                '';
                description = ''
                  Packages from which to derive Portmaster fingerprints.

                  A package can be specified directly for the default matching
                  behavior, or as an attribute set to customize its generated
                  fingerprint. Package-derived regular expressions do not include
                  a specific store hash or package version and also match
                  Nix-generated `.program-wrapped` executables by default.
                '';
              };

              fingerprints = mkOption {
                type = types.listOf fingerprintType;
                default = [ ];
                example = [
                  {
                    type = "env";
                    key = "CHROME_DESKTOP";
                    operation = "equals";
                    value = "vesktop.desktop";
                  }
                ];
                description = ''
                  Additional Portmaster fingerprints for this profile. These are
                  merged with fingerprints generated from `packages`.

                  Portmaster fingerprints are ORed, not ANDed, so broad
                  fingerprints can match unrelated applications.
                '';
              };

              settings = mkOption {
                type = types.submodule {
                  freeformType = settingsFormat.type;
                  options = { };
                };
                default = { };
                example = {
                  filter.defaultAction = "permit";
                };
                description = ''
                  Per-application Portmaster settings for this profile, using the
                  upstream nested per-app configuration shape such as
                  `history.enable`, `filter.defaultAction`, or `spn.use`.
                  Global-only settings are rejected by Portmaster during sync.

                  Do not put secrets here; generated profile payloads are stored in
                  the Nix store.
                '';
              };
            };
          }
        )
      );
      default = { };
      example = literalExpression ''
        {
          Firefox = {
            packages = [ pkgs.firefox ];
            settings.filter.defaultAction = "permit";
          };
        }
      '';
      description = ''
        Declarative per-application profiles keyed by logical name.

        Profiles are imported through Portmaster's profile import API with
        `allowReplace`. Package-derived regular expressions remain stable across
        package updates. At least one entry in `packages` or `fingerprints` is
        required. Changing a profile's normalized
        fingerprints creates a different Portmaster identity and can leave the
        previous imported profile behind. Removing a declaration does not delete
        a previously imported profile.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--print-stack-on-exit" ];
      description = ''
        Extra command-line arguments to pass to portmaster-core.
        Do not include secrets because these arguments are visible in the
        generated systemd unit and process list.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = optional profilesEnabled {
      assertion = profileErrors == [ ] && profileIdentityCollisions == [ ];
      message = ''
        services.portmaster.profiles must be valid and have unique normalized fingerprints; ${
          concatStringsSep "; " (
            profileErrors ++ map formatProfileIdentityCollision profileIdentityCollisions
          )
        }
      '';
    };

    environment.systemPackages = [ cfg.package ];

    boot.kernelModules = [ "nfnetlink_queue" ];

    systemd = {
      tmpfiles.settings."10-portmaster" = genAttrs tmpfileDirectories (_: {
        d = tmpfileDir;
      });

      services.portmaster = {
        description = "Portmaster by Safing";
        documentation = [
          "https://safing.io"
          "https://docs.safing.io"
        ];
        before = [
          "nss-lookup.target"
          "network.target"
          "shutdown.target"
        ];
        after = [
          "systemd-networkd.service"
          "systemd-tmpfiles-setup.service"
        ];
        conflicts = [
          "shutdown.target"
          "firewalld.service"
        ];
        wants = [ "nss-lookup.target" ];
        wantedBy = [ "multi-user.target" ];
        requires = [ "systemd-tmpfiles-setup.service" ];

        preStart =
          lib.optionalString (!managesConfig) ''
            if [ -e ${escapeShellArg runtimeConfigManagedMarkerPath} ]; then
              ${getExe' pkgs.coreutils "rm"} -f ${escapeShellArg runtimeConfigPath} ${escapeShellArg runtimeConfigManagedMarkerPath}
            fi
          ''
          + lib.optionalString (!profilesEnabled) ''
            ${getExe' pkgs.coreutils "rm"} -f ${escapeShellArg profilesApiKeyPath}
          ''
          + lib.optionalString managesConfig ''
            ${mergeConfig}
          '';

        serviceConfig =
          let
            baseArgs = [
              (getExe' cfg.package "portmaster-core")
              "--bin-dir=${packageLibDir}"
              "--data-dir=${stateDir}"
              "--log-dir=${logsDir}"
            ];
            devmodeArgs = optional (!managesConfig && cfg.settings.devmode) "--devmode";
          in
          {
            Type = "simple";
            ExecStart = utils.escapeSystemdExecArgs (baseArgs ++ devmodeArgs ++ cfg.extraArgs);
            ExecStopPost = "-${getExe' cfg.package "portmaster-core"} recover-iptables";
            Restart = "on-failure";
            RestartSec = "10";
            RestartPreventExitStatus = "24";
            User = "root";
            Group = "root";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            MemoryLow = "2G";
            NoNewPrivileges = true;
            PrivateTmp = true;
            PIDFile = "${stateDir}/core-lock.pid";
            WorkingDirectory = stateDir;
            ProtectSystem = true;
            ReadOnlyPaths = [ builtins.storeDir ];
            ReadWritePaths = [ stateDir ];
            ProtectHome = "read-only";
            ProtectKernelTunables = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            PrivateDevices = true;
            RestrictNamespaces = true;
            AmbientCapabilities = portmasterCapabilities;
            CapabilityBoundingSet = portmasterCapabilities;
            RestrictAddressFamilies = [
              "AF_UNIX"
              "AF_NETLINK"
              "AF_INET"
              "AF_INET6"
            ];
            Environment = [ "LOGLEVEL=info" ];
          };
      };

      services.portmaster-managed-profiles = mkIf profilesEnabled {
        description = "Sync declarative Portmaster managed profiles";
        wantedBy = [ "portmaster.service" ];
        after = [ "portmaster.service" ];
        partOf = [ "portmaster.service" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          LoadCredential = [ "managed-profiles-api-key:${profilesApiKeyPath}" ];
          AmbientCapabilities = [ ];
          CapabilityBoundingSet = [ ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectKernelLogs = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          UMask = "0077";
        };

        script = ''
          set -euo pipefail

          curl_config="$(${getExe' pkgs.coreutils "mktemp"} --tmpdir portmaster-managed-profiles-curl.XXXXXX)"
          response_file="$(${getExe' pkgs.coreutils "mktemp"} --tmpdir portmaster-managed-profiles-response.XXXXXX)"
          cleanup() {
            ${getExe' pkgs.coreutils "rm"} -f "$curl_config" "$response_file"
          }
          trap cleanup EXIT
          ${getExe' pkgs.coreutils "chmod"} 0600 "$curl_config" "$response_file"

          managed_api_key="$(${getExe' pkgs.coreutils "tr"} -d '\r\n' < "$CREDENTIALS_DIRECTORY/managed-profiles-api-key")"
          if [[ ! "$managed_api_key" =~ ^[0-9a-f]{64}$ ]]; then
            printf >&2 '%s\n' "Portmaster managed profiles API key credential is invalid"
            exit 1
          fi

          printf 'header = "Authorization: Bearer %s"\n' "$managed_api_key" > "$curl_config"
          unset managed_api_key

          ready=0
          for _ in $(${getExe' pkgs.coreutils "seq"} 1 60); do
            if ${getExe pkgs.curl} --silent --fail --noproxy '*' --max-time 2 ${escapeShellArg profilesPingUrl} > /dev/null; then
              ready=1
              break
            fi
            ${getExe' pkgs.coreutils "sleep"} 1
          done

          if [ "$ready" -ne 1 ]; then
            printf >&2 '%s\n' "Portmaster API at ${profilesPingUrl} did not become ready in time"
            exit 1
          fi

          import_profile() {
            local logical_name="$1"
            local profile="$2"

            if ! ${getExe pkgs.jq} -e '
              .type == "profile"
              and (.source == "local")
              and (.name | type == "string" and length > 0)
              and (.config | type == "object")
              and (.fingerprints | type == "array")
              and (.fingerprints | length > 0)
              and (has("id") | not)
              and all(
                .fingerprints[];
                (.type == "path" or .type == "cmdline" or .type == "env" or .type == "tag")
                and (.operation == "equals" or .operation == "prefix" or .operation == "regex")
                and (.value | type == "string" and length > 0)
                and (
                  if (.type == "env" or .type == "tag") then
                    (.key | type == "string" and length > 0)
                  else
                    (has("key") | not)
                  end
                )
              )
            ' "$profile" > /dev/null
            then
              printf >&2 'Invalid generated Portmaster profile `%s` (%s)\n' "$logical_name" "$profile"
              exit 1
            fi

            : > "$response_file"
            if ${getExe pkgs.curl} \
              --config "$curl_config" \
              --silent \
              --show-error \
              --fail-with-body \
              --noproxy '*' \
              --max-time 30 \
              --header "Content-Type: application/json" \
              --data-binary @"$profile" \
              --output "$response_file" \
              ${escapeShellArg profilesImportUrl}
            then
              :
            else
              curl_status=$?
              printf >&2 'Failed to import Portmaster profile `%s` from %s (curl exit %s)\n' \
                "$logical_name" "$profile" "$curl_status"
              if [ -s "$response_file" ]; then
                printf >&2 '%s\n' 'Portmaster response:'
                ${getExe' pkgs.coreutils "cat"} "$response_file" >&2
                printf >&2 '\n'
              fi
              exit "$curl_status"
            fi

            if ! ${getExe pkgs.jq} -e '
              (.restartRequired | type == "boolean")
              and (.replacesExisting | type == "boolean")
            ' "$response_file" > /dev/null
            then
              printf >&2 'Portmaster returned an invalid response while importing profile `%s` from %s:\n' \
                "$logical_name" "$profile"
              ${getExe' pkgs.coreutils "cat"} "$response_file" >&2
              printf >&2 '\n'
              exit 1
            fi
          }

          ${concatMapStringsSep "\n" (
            profile: "import_profile ${escapeShellArg profile.logicalName} ${escapeShellArg profile.path}"
          ) profileExports}
        '';
      };
    };
  };

  meta = {
    doc = ./portmaster.md;
    maintainers = with lib.maintainers; [
      WitteShadovv
      nyabinary
    ];
  };
}
