{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    boolToString
    concatMapStringsSep
    concatStringsSep
    escapeShellArg
    escapeShellArgs
    genAttrs
    getName
    hasPrefix
    mapAttrs
    mapAttrsToList
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    optionals
    types
    unique
    ;
  inherit (lib.strings) sanitizeDerivationName;

  cfg = config.services.portmaster;
  settingsFormat = pkgs.formats.json { };

  nonEmptyStringType = types.addCheck types.str (value: value != "");
  absolutePathStringType = types.addCheck types.str (hasPrefix "/");
  absoluteExecutablePathType = types.oneOf [
    (types.pathWith {
      absolute = true;
      inStore = false;
    })
    absolutePathStringType
  ];

  fingerprintType = types.submodule {
    options = {
      type = mkOption {
        type = types.enum [
          "path"
          "cmdline"
        ];
        description = "Fingerprint matching strategy: `path` matches executable paths, `cmdline` matches full command lines.";
      };
      operation = mkOption {
        type = types.enum [
          "equals"
          "regex"
        ];
        description = "How to match the fingerprint value: `equals` for exact string match, `regex` for regular expression match.";
      };
      value = mkOption {
        type = nonEmptyStringType;
        description = "The value to match against.";
      };
    };
  };

  normalizeFingerprint = fingerprint: {
    inherit (fingerprint) type operation;
    # Portmaster profile identity is pure JSON. Drop Nix string context so
    # equivalent store-backed and plain strings collide deterministically.
    value = builtins.unsafeDiscardStringContext (toString fingerprint.value);
  };

  normalizeFingerprints =
    fingerprints:
    map builtins.fromJSON (
      unique (
        builtins.sort builtins.lessThan (
          map (fingerprint: builtins.toJSON (normalizeFingerprint fingerprint)) fingerprints
        )
      )
    );

  normalizePaths =
    paths:
    unique (
      builtins.sort builtins.lessThan (
        map (path: builtins.unsafeDiscardStringContext (toString path)) paths
      )
    );

  mkPathFingerprint = path: {
    type = "path";
    operation = "equals";
    value = path;
  };

  getLauncherName =
    profileCfg:
    if profileCfg.identity.launcher != null then
      profileCfg.identity.launcher
    else
      profileCfg.package.meta.mainProgram or (getName profileCfg.package);

  autoPackageFingerprints = {
    brave = package: [ (mkPathFingerprint "${package}/opt/brave.com/brave/brave") ];
    librewolf = package: [ (mkPathFingerprint "${package}/lib/librewolf/librewolf") ];
  };

  derivePackageFingerprints =
    profileCfg:
    let
      packageName = getName profileCfg.package;
      fingerprintsForPackage = autoPackageFingerprints.${packageName} or null;
    in
    if fingerprintsForPackage != null && getLauncherName profileCfg == packageName then
      fingerprintsForPackage profileCfg.package
    else
      null;

  stateDir = "/var/lib/portmaster";
  runtimeDir = "${stateDir}/runtime";
  logsDir = "${stateDir}/logs";
  configDir = "${stateDir}/config";
  usrLibDir = "/usr/lib/portmaster";
  packageLibDir = "${cfg.package}/lib/portmaster";

  runtimeConfigPath = "${runtimeDir}/config.json";
  runtimeConfigManagedMarkerPath = "${runtimeDir}/.config.json.nix-managed";
  managedProfilesApiKeyPath = "${configDir}/nix-managed-managed-profiles-api-key";
  legacyManagedProfilesApiKeyEntryPath = "${configDir}/nix-managed-managed-profiles-api-key-entry";

  managedProfilesApiBaseUrl = "http://127.0.0.1:817/api/v1";
  managedProfilesPingUrl = "${managedProfilesApiBaseUrl}/ping";
  managedProfilesImportUrl = "${managedProfilesApiBaseUrl}/sync/profile/import?allowReplace";

  configSettings = builtins.removeAttrs cfg.settings [ "devmode" ];
  hasExternalConfigInputs = cfg.settingsFile != null || cfg.secretsFile != null;
  managedProfilesEnabled = cfg.managedProfiles != { };
  shouldGenerateManagedConfig =
    configSettings != { } || hasExternalConfigInputs || managedProfilesEnabled;

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
    "${stateDir}/download_binaries"
    "${stateDir}/updates"
    "${stateDir}/databases"
    "${stateDir}/databases/icons"
    configDir
    "${stateDir}/intel"
    runtimeDir
    usrLibDir
  ];

  tmpfileLinks = {
    # Portmaster expects its mutable installation/runtime tree under the data
    # directory; the service starts core through this compatibility symlink.
    "${runtimeDir}/portmaster-core" = "${packageLibDir}/portmaster-core";
    "${runtimeDir}/portmaster" = "${packageLibDir}/portmaster";
    "${runtimeDir}/portmaster.zip" = "${packageLibDir}/portmaster.zip";
    "${runtimeDir}/assets.zip" = "${packageLibDir}/assets.zip";

    # Upstream also probes /usr/lib/portmaster for bundled ZIP assets.
    "${usrLibDir}/portmaster.zip" = "${packageLibDir}/portmaster.zip";
    "${usrLibDir}/assets.zip" = "${packageLibDir}/assets.zip";
  };

  mkTmpfileLink = argument: { "L+" = { inherit argument; }; };

  mkProfileResolution =
    logicalName: profileCfg:
    let
      normalizedPaths = normalizePaths profileCfg.match.paths;
      hasLegacyPaths = normalizedPaths != [ ];
      hasPackage = profileCfg.package != null;
      hasManualFingerprints = profileCfg.identity.fingerprints != null;
      hasExtraFingerprints = profileCfg.identity.extraFingerprints != [ ];
      autoFingerprints = if hasPackage then derivePackageFingerprints profileCfg else null;
      baseFingerprints =
        if hasManualFingerprints then
          normalizeFingerprints profileCfg.identity.fingerprints
        else if hasLegacyPaths then
          map mkPathFingerprint normalizedPaths
        else if autoFingerprints != null then
          normalizeFingerprints autoFingerprints
        else
          [ ];
      error =
        if hasPackage && hasLegacyPaths then
          "`package` and legacy `match.paths` cannot be combined"
        else if hasManualFingerprints && hasLegacyPaths then
          "`identity.fingerprints` and legacy `match.paths` cannot be combined"
        else if hasManualFingerprints && hasExtraFingerprints then
          "`identity.fingerprints` is a full override and cannot be combined with `identity.extraFingerprints`"
        else if !(hasManualFingerprints || hasLegacyPaths || hasPackage) then
          "one of `package`, legacy `match.paths`, or `identity.fingerprints` must be set"
        else if hasPackage && autoFingerprints == null && !hasManualFingerprints && !hasLegacyPaths then
          "automatic identity derivation supports only a small exact-path allowlist; set `identity.fingerprints` or legacy `match.paths` explicitly for unsupported packages or launchers"
        else
          null;
      fingerprints =
        if error != null then
          [ ]
        else if hasManualFingerprints then
          baseFingerprints
        else
          normalizeFingerprints (baseFingerprints ++ profileCfg.identity.extraFingerprints);
    in
    {
      inherit logicalName error fingerprints;
      inherit (profileCfg) name settings;
    };

  profileResolutions = mapAttrs mkProfileResolution cfg.managedProfiles;
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

  profileIdentityEntries = mapAttrsToList (logicalName: resolution: {
    inherit logicalName;
    normalizedFingerprints = resolution.fingerprints;
    identityKey = builtins.toJSON resolution.fingerprints;
  }) profileResolutions;

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

  profileExports = mapAttrsToList (
    logicalName: resolution:
    settingsFormat.generate "portmaster-profile-${sanitizeDerivationName logicalName}.json" (
      mkProfilePayload resolution
    )
  ) profileResolutions;

  mergeConfig = pkgs.writeShellScript "portmaster-merge-config" ''
    set -euo pipefail

    umask 077
    key_tmp=
    trap 'rm -f ${escapeShellArg runtimeConfigPath}.tmp "''${key_tmp:-}"' EXIT

    inputs=(
    ${concatMapStringsSep "\n" (input: "  ${escapeShellArg (toString input)}") managedConfigMergeInputs}
    )

    ${lib.optionalString managedProfilesEnabled ''
      if [ ! -s ${escapeShellArg managedProfilesApiKeyPath} ]; then
        key_tmp="$(${pkgs.coreutils}/bin/mktemp ${escapeShellArg "${configDir}/.nix-managed-managed-profiles-api-key.XXXXXX"})"
        ${pkgs.coreutils}/bin/od -An -tx1 -N32 /dev/urandom | ${pkgs.coreutils}/bin/tr -d ' \n' > "$key_tmp"
        if [ "$(${pkgs.coreutils}/bin/wc -c < "$key_tmp")" -ne 64 ]; then
          printf >&2 '%s\n' "Failed to generate Portmaster managed profiles API key"
          exit 1
        fi
        ${pkgs.coreutils}/bin/install -m 0600 -o root -g root "$key_tmp" ${escapeShellArg managedProfilesApiKeyPath}
        ${pkgs.coreutils}/bin/rm -f "$key_tmp"
        key_tmp=
      fi

      ${pkgs.coreutils}/bin/chown root:root ${escapeShellArg managedProfilesApiKeyPath}
      ${pkgs.coreutils}/bin/chmod 0600 ${escapeShellArg managedProfilesApiKeyPath}
    ''}

    if [ "''${#inputs[@]}" -eq 0 ]; then
      exit 0
    fi

    for input in "''${inputs[@]}"; do
      if ! ${pkgs.jq}/bin/jq -e '
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
    ${lib.optionalString managedProfilesEnabled ''
      jq_merge_args+=(--rawfile managedProfilesApiKey ${escapeShellArg managedProfilesApiKeyPath})
    ''}

    ${pkgs.jq}/bin/jq "''${jq_merge_args[@]}" '
      reduce .[] as $item ({}; . * $item)
      ${lib.optionalString managedProfilesEnabled ''
          | if has("core/apiKeys") and (."core/apiKeys" | type != "array") then
              error("core/apiKeys must be an array")
            else
              .
            end
        | (."core/apiKeys" // []) as $apiKeys
        | (($managedProfilesApiKey | gsub("[\\r\\n]"; "")) + "?read=admin&write=admin") as $managedApiKey
          | ."core/apiKeys" = (
              $apiKeys + (if ($apiKeys | index($managedApiKey)) then [] else [ $managedApiKey ] end)
            )
      ''}
    ' "''${inputs[@]}" > ${escapeShellArg runtimeConfigPath}.tmp
    ${pkgs.coreutils}/bin/install -m 0600 ${escapeShellArg runtimeConfigPath}.tmp ${escapeShellArg runtimeConfigPath}
    : > ${escapeShellArg runtimeConfigManagedMarkerPath}
    ${pkgs.coreutils}/bin/chmod 0600 ${escapeShellArg runtimeConfigManagedMarkerPath}
  '';
in
{
  options.services.portmaster = {
    enable = mkEnableOption "Portmaster application firewall";

    package = mkPackageOption pkgs "portmaster" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options.devmode = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Enable development mode. This makes the Portmaster UI available at 127.0.0.1:817.
          '';
        };
      };
      default = { };
      description = ''
        Global Portmaster settings for runtime {file}`config.json`.
        Per-application profiles are managed by {option}`managedProfiles`.

        Merge order is recursive and later inputs win: this option,
        {option}`settingsFile`, then {option}`secretsFile`.

        Do not put secrets here; values are stored in the Nix store. Use
        {option}`secretsFile` instead.
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

    managedProfiles = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              name = mkOption {
                type = nonEmptyStringType;
                default = name;
                description = ''
                  Human-readable Portmaster profile name.
                '';
              };

              package = mkOption {
                type = types.nullOr types.package;
                default = null;
                description = ''
                  Package from which to derive this profile's Portmaster identity.
                  Derivation uses a small exact-path allowlist and fails closed for
                  unsupported package layouts.
                '';
              };

              identity = {
                launcher = mkOption {
                  type = types.nullOr nonEmptyStringType;
                  default = null;
                  description = ''
                    Executable name under the package's {file}`bin/` directory to
                    use for package identity. Automatic derivation still succeeds
                    only for allowlisted exact paths.
                  '';
                };

                extraFingerprints = mkOption {
                  type = types.listOf fingerprintType;
                  default = [ ];
                  description = ''
                    Additional Portmaster fingerprints to append to the derived
                    profile identity.

                    Portmaster fingerprints are ORed, not ANDed, so adding broad
                    fingerprints can overmatch unrelated applications.
                  '';
                };

                fingerprints = mkOption {
                  type = types.nullOr (types.nonEmptyListOf fingerprintType);
                  default = null;
                  description = ''
                    Full manual Portmaster fingerprint list for this profile.

                    When set, this bypasses automatic package derivation entirely.
                    Portmaster fingerprints are ORed, not ANDed.
                  '';
                };
              };

              match.paths = mkOption {
                type = types.listOf absoluteExecutablePathType;
                default = [ ];
                description = ''
                  Legacy exact executable paths for this profile.

                  Store-backed paths are normalized to plain sorted, deduplicated
                  strings before export. New configurations should prefer
                  {option}`package` for allowlisted applications, or manual
                  fingerprints for unsupported applications.

                  These paths are part of the Portmaster profile identity. Changing
                  them may create a new remote profile instead of replacing the old
                  one.
                '';
              };

              settings = mkOption {
                type = types.submodule {
                  freeformType = settingsFormat.type;
                  options = { };
                };
                default = { };
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
      description = ''
        Declarative per-application profiles keyed by logical name.

        Profiles are imported through Portmaster's profile import API with
        `allowReplace`. Replacement depends on stable normalized fingerprints:
        changing package-derived identity, manual fingerprints, or legacy paths
        may create a new remote profile and leave the old one behind. Removing a
        declaration does not delete previously imported profiles.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra command-line arguments to pass to portmaster-core.
      '';
    };
  };

  config = mkMerge [
    {
      assertions = optional managedProfilesEnabled {
        assertion = profileErrors == [ ] && profileIdentityCollisions == [ ];
        message = ''
          services.portmaster.managedProfiles must be valid and have unique normalized fingerprints; ${
            concatStringsSep "; " (
              profileErrors ++ map formatProfileIdentityCollision profileIdentityCollisions
            )
          }
        '';
      };

      system.activationScripts.portmaster-cleanup = ''
        if ${boolToString (!(cfg.enable && managesConfig))}; then
          if [ -e ${escapeShellArg runtimeConfigManagedMarkerPath} ]; then
            rm -f ${escapeShellArg runtimeConfigPath} ${escapeShellArg runtimeConfigManagedMarkerPath}
          fi
        fi

        rm -f ${escapeShellArg legacyManagedProfilesApiKeyEntryPath}
        if ${boolToString (!(cfg.enable && managedProfilesEnabled))}; then
          rm -f ${escapeShellArg managedProfilesApiKeyPath}
        fi
      '';
    }

    (mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      boot.kernelModules = [ "nfnetlink_queue" ];

      systemd = {
        tmpfiles.settings."10-portmaster" =
          genAttrs tmpfileDirectories (_: {
            d = tmpfileDir;
          })
          // mapAttrs (_: mkTmpfileLink) tmpfileLinks;

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

          preStart = lib.optionalString managesConfig ''
            ${mergeConfig}
          '';

          postStop = ''
            ${runtimeDir}/portmaster-core recover-iptables
          '';

          serviceConfig =
            let
              baseArgs = [
                "${runtimeDir}/portmaster-core"
                "--data-dir=${runtimeDir}"
                "--log-dir=${logsDir}"
              ];
              devmodeArgs = optional (!managesConfig && cfg.settings.devmode) "--devmode";
            in
            {
              Type = "simple";
              ExecStart = utils.escapeSystemdExecArgs (baseArgs ++ devmodeArgs ++ cfg.extraArgs);
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
              StateDirectory = "portmaster";
              WorkingDirectory = stateDir;
              ProtectSystem = true;
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
              Environment = [
                "LOGLEVEL=info"
                "PORTMASTER_DATA_DIR=${stateDir}"
                "PORTMASTER_RUNTIME_DIR=${runtimeDir}"
              ];
            };
        };

        services.portmaster-managed-profiles = mkIf managedProfilesEnabled {
          description = "Sync declarative Portmaster managed profiles";
          wantedBy = [ "portmaster.service" ];
          after = [ "portmaster.service" ];
          partOf = [ "portmaster.service" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            LoadCredential = [ "managed-profiles-api-key:${managedProfilesApiKeyPath}" ];
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

            curl_config="$(${pkgs.coreutils}/bin/mktemp --tmpdir portmaster-managed-profiles-curl.XXXXXX)"
            trap '${pkgs.coreutils}/bin/rm -f "$curl_config"' EXIT
            ${pkgs.coreutils}/bin/chmod 0600 "$curl_config"
            printf '%s' 'header = "Authorization: Bearer ' > "$curl_config"
            ${pkgs.coreutils}/bin/tr -d '\r\n' < "$CREDENTIALS_DIRECTORY/managed-profiles-api-key" >> "$curl_config"
            printf '%s\n' '"' >> "$curl_config"

            if [ "$(${pkgs.coreutils}/bin/wc -c < "$curl_config")" -le 34 ]; then
              printf >&2 '%s\n' "Portmaster managed profiles API key credential is empty"
              exit 1
            fi

            ready=0
            for _ in $(${pkgs.coreutils}/bin/seq 1 60); do
              if ${pkgs.curl}/bin/curl --silent --show-error --fail --noproxy '*' --max-time 2 ${escapeShellArg managedProfilesPingUrl} > /dev/null; then
                ready=1
                break
              fi
              ${pkgs.coreutils}/bin/sleep 1
            done

            if [ "$ready" -ne 1 ]; then
              printf >&2 '%s\n' "Portmaster API at ${managedProfilesPingUrl} did not become ready in time"
              exit 1
            fi

            for profile in ${escapeShellArgs profileExports}; do
              ${pkgs.jq}/bin/jq -e '
                .type == "profile"
                and (.source == "local")
                and (.name | type == "string" and length > 0)
                and (.config | type == "object")
                and (.fingerprints | type == "array")
                and (.fingerprints | length > 0)
                and (has("id") | not)
                and all(
                  .fingerprints[];
                  (.type == "path" or .type == "cmdline")
                  and (.operation == "equals" or .operation == "regex")
                  and (.value | type == "string" and length > 0)
                )
              ' "$profile" > /dev/null

              response="$(${pkgs.curl}/bin/curl \
                --config "$curl_config" \
                --silent \
                --show-error \
                --fail \
                --noproxy '*' \
                --max-time 30 \
                --header "Content-Type: application/json" \
                --data-binary @"$profile" \
                ${escapeShellArg managedProfilesImportUrl})"

              printf '%s' "$response" | ${pkgs.jq}/bin/jq -e '
                (.restartRequired | type == "boolean")
                and (.replacesExisting | type == "boolean")
              ' > /dev/null
            done
          '';
        };
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [
    WitteShadovv
    nyabinary
  ];
}
