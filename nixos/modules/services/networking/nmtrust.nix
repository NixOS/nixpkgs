{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nmtrust;

  # Resolve trusted UUIDs from ensureProfiles + extra
  profileUUIDs = map (
    name: config.networking.networkmanager.ensureProfiles.profiles.${name}.connection.uuid
  ) cfg.trustedConnections;

  trustedUUIDs = profileUUIDs ++ cfg.trustedUUIDsExtra;

  userNames = builtins.attrNames cfg.userUnits;

  # The package reads config from /etc/nmtrust/config at runtime
  trustHelper = pkgs.nmtrust;

  # Trust target names
  trustTargets = [
    "nmtrust-trusted"
    "nmtrust-untrusted"
    "nmtrust-offline"
  ];

  # Generate Conflicts= for a target (all other trust targets)
  conflictsFor = target: map (t: "${t}.target") (builtins.filter (t: t != target) trustTargets);

  # Uses StopWhenUnneeded instead of PartOf to avoid same-transaction
  # issues: when transitioning between targets that both want a unit
  # (e.g. offline -> trusted for allowOffline units), PartOf on the
  # old target would stop the unit before WantedBy on the new target
  # can restart it. StopWhenUnneeded only stops the unit when NO
  # active target wants it.
  mkUnitOverrides =
    unitName: unitCfg:
    let
      targets = [
        "nmtrust-trusted.target"
      ]
      ++ lib.optional unitCfg.allowOffline "nmtrust-offline.target";
    in
    {
      unitConfig.StopWhenUnneeded = true;
      wantedBy = targets;
    };

  # NM dispatcher script
  dispatcherScript = pkgs.writeShellScript "nmtrust-dispatcher" ''
    case "$2" in
      up|down|vpn-up|vpn-down|connectivity-change)
        ${config.systemd.package}/bin/systemd-run \
          --no-block \
          --on-active=1s \
          --unit=nmtrust-apply-debounce \
          ${config.systemd.package}/bin/systemctl start nmtrust-apply.service \
          2>/dev/null || true
        ;;
    esac
  '';

in
{

  #
  # Options
  #

  options.services.nmtrust = {

    enable = lib.mkEnableOption "network trust management";

    trustedConnections = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of NetworkManager profile names from
        {option}`networking.networkmanager.ensureProfiles`.
        UUIDs are resolved at evaluation time.
      '';
    };

    trustedUUIDsExtra = lib.mkOption {
      type = lib.types.listOf (
        lib.types.strMatching "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
      );
      default = [ ];
      description = ''
        Additional trusted connection UUIDs not managed via
        {option}`networking.networkmanager.ensureProfiles`.
        Must be valid UUID format.
      '';
    };

    excludedConnectionPatterns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Glob patterns matched against connection names at runtime using
        fnmatch(3) with FNM_NOESCAPE. Connection names are treated as
        literal strings (no backslash interpretation).
        Matching connections are ignored when computing trust state.
      '';
    };

    mixedPolicy = lib.mkOption {
      type = lib.types.enum [
        "trusted"
        "untrusted"
      ];
      default = "untrusted";
      description = ''
        How to treat mixed trust state (some connections trusted,
        some untrusted).
      '';
    };

    evalFailurePolicy = lib.mkOption {
      type = lib.types.enum [
        "untrusted"
        "offline"
      ];
      default = "untrusted";
      description = ''
        How to handle trust evaluation failures (D-Bus errors, NM
        unavailable). `"untrusted"` (default) is fail-closed: trusted-only
        units stop. `"offline"` allows units with
        {option}`allowOffline` to run.
      '';
    };

    systemUnits = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.allowOffline = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether this unit should also run when offline.";
          };
        }
      );
      default = { };
      description = ''
        System units to bind to the trusted network target.
        Keys are systemd unit names.
      '';
    };

    userUnits = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.attrsOf (
          lib.types.submodule {
            options.allowOffline = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether this unit should also run when offline.";
            };
          }
        )
      );
      default = { };
      example = lib.literalExpression ''
        {
          alice = {
            "etesync-dav.service" = { };
            "syncthing.service" = { allowOffline = true; };
          };
        }
      '';
      description = ''
        Per-user units to bind to the trusted network target.
        Outer keys are usernames, inner keys are systemd unit names.
        Users must have linger enabled
        ({option}`users.users.<name>.linger`).
      '';
    };
  };

  #
  # Config
  #

  config = lib.mkIf cfg.enable {

    # --- Assertions ---

    assertions =
      # NetworkManager is required
      [
        {
          assertion = config.networking.networkmanager.enable;
          message = "services.nmtrust requires networking.networkmanager.enable = true.";
        }
      ]
      ++
        # trustedConnections -> ensureProfiles UUID resolution
        (map (name: {
          assertion =
            config.networking.networkmanager.ensureProfiles.profiles ? ${name}
            && config.networking.networkmanager.ensureProfiles.profiles.${name}.connection ? uuid;
          message =
            "services.nmtrust.trustedConnections references '${name}' "
            + "but no matching networking.networkmanager.ensureProfiles entry with a UUID exists.";
        }) cfg.trustedConnections)
      ++
        # userUnits -> user existence
        (map (username: {
          assertion = config.users.users ? ${username};
          message =
            "services.nmtrust.userUnits references user '${username}' "
            + "but no matching users.users entry exists.";
        }) userNames)
      ++
        # userUnits -> linger enabled
        (map (username: {
          assertion =
            let
              l = config.users.users.${username}.linger;
            in
            l != null && l;
          message =
            "services.nmtrust.userUnits references user '${username}' but "
            + "linger is not enabled. Set users.users.${username}.linger = true to "
            + "ensure the user's systemd instance is running for trust-based unit management. "
            + "Note: enabling linger causes ALL of this user's enabled user services to run "
            + "persistently, not just trust-managed units.";
        }) (builtins.filter (u: config.users.users ? ${u}) userNames));

    # --- Helper package on PATH ---

    environment.systemPackages = [ trustHelper ];

    # --- Runtime config file ---

    environment.etc."nmtrust/config" = {
      text =
        let
          toBashArray = xs: "(" + lib.concatMapStringsSep " " (x: lib.escapeShellArg x) xs + ")";
        in
        ''
          # Generated by NixOS module — do not edit
          TRUSTED_UUIDS=${toBashArray trustedUUIDs}
          EXCLUDED_PATTERNS=${toBashArray (cfg.excludedConnectionPatterns)}
          MIXED_POLICY=${lib.escapeShellArg cfg.mixedPolicy}
          EVAL_FAILURE_POLICY=${lib.escapeShellArg cfg.evalFailurePolicy}
          MANAGED_USERS=${toBashArray userNames}
        '';
    };

    # --- tmpfiles.d ---

    systemd.tmpfiles.rules = [
      "d /run/nmtrust 0700 root root -"
    ];

    # --- System trust targets ---

    systemd.targets = lib.listToAttrs (
      map (target: {
        name = target;
        value = {
          description = "Network Trust State: ${
            if target == "nmtrust-trusted" then
              "Trusted"
            else if target == "nmtrust-untrusted" then
              "Untrusted"
            else
              "Offline"
          }";
          unitConfig.Conflicts = conflictsFor target;
        };
      }) trustTargets
    );

    # --- User trust targets ---

    systemd.user.targets = lib.listToAttrs (
      map (target: {
        name = target;
        value = {
          description = "Network Trust State: ${
            if target == "nmtrust-trusted" then
              "Trusted (User)"
            else if target == "nmtrust-untrusted" then
              "Untrusted (User)"
            else
              "Offline (User)"
          }";
          unitConfig.Conflicts = conflictsFor target;
        };
      }) trustTargets
    );

    # --- System unit overrides + services ---

    # Strip .service/.timer/.socket suffixes — NixOS appends them automatically
    systemd.services =
      lib.mapAttrs' (name: value: {
        name = lib.removeSuffix ".service" (lib.removeSuffix ".timer" (lib.removeSuffix ".socket" name));
        value = mkUnitOverrides name value;
      }) cfg.systemUnits
      // {
        nmtrust-apply = {
          description = "Evaluate and apply network trust state";
          after = [ "NetworkManager.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${trustHelper}/bin/nmtrust apply";
            Restart = "on-failure";
            RestartSec = "5";
            ProtectSystem = "strict";
            ReadWritePaths = [ "/run/nmtrust" ];
            ProtectHome = true;
            NoNewPrivileges = true;
            PrivateTmp = true;
          };
        };
        nmtrust-eval = {
          description = "Evaluate network trust state on boot";
          wantedBy = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          after = [
            "NetworkManager.service"
            "network-online.target"
          ];
          restartTriggers = [
            config.environment.etc."nmtrust/config".source
          ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${trustHelper}/bin/nmtrust apply";
            Restart = "on-failure";
            RestartSec = "5";
            ProtectSystem = "strict";
            ReadWritePaths = [ "/run/nmtrust" ];
            ProtectHome = true;
            NoNewPrivileges = true;
            PrivateTmp = true;
          };
        };
      };

    # --- User unit overrides ---

    # When the same unit appears under multiple users, union their wantedBy
    # lists. systemd.user.services is system-wide, so per-user allowOffline
    # differences are resolved by taking the most permissive value (any
    # true wins).
    systemd.user.services = lib.foldl' (
      acc: username:
      lib.foldl' (
        acc': unitName:
        let
          strippedName = lib.removeSuffix ".service" (
            lib.removeSuffix ".timer" (lib.removeSuffix ".socket" unitName)
          );
          incoming = mkUnitOverrides unitName cfg.userUnits.${username}.${unitName};
          existing = acc'.${strippedName} or null;
        in
        acc'
        // {
          ${strippedName} =
            if existing == null then
              incoming
            else
              existing
              // {
                wantedBy = lib.unique (existing.wantedBy ++ incoming.wantedBy);
              };
        }
      ) acc (builtins.attrNames cfg.userUnits.${username})
    ) { } userNames;

    # --- NM dispatcher ---

    networking.networkmanager.dispatcherScripts = [
      {
        source = dispatcherScript;
        type = "basic";
      }
    ];
  };

  meta.maintainers = [ lib.maintainers.brett ];

}
