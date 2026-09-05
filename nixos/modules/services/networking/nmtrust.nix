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

  # Unit names across all users, deduplicated: systemd.user.* is
  # system-wide, so the same unit named by two users is one unit.
  sharedUserUnitNames = lib.unique (
    lib.concatMap (username: builtins.attrNames cfg.userUnits.${username}) userNames
  );

  # The package reads config from /etc/nmtrust/config at runtime
  trustHelper = pkgs.nmtrust;

  # Trust states, and the target names derived from them
  trustStates = [
    "trusted"
    "untrusted"
    "offline"
  ];

  trustTargets = map (state: "nmtrust-${state}") trustStates;

  # Fully-qualified target unit names, used to tell nmtrust's own
  # dependencies apart from foreign ones in assertions.
  trustTargetUnits = map (t: "${t}.target") trustTargets;

  # Generate Conflicts= for a target (all other trust targets)
  conflictsFor = target: map (t: "${t}.target") (builtins.filter (t: t != target) trustTargets);

  # Unit types nmtrust can bind, mapped to the NixOS option set that owns
  # them. NixOS appends the type suffix itself, so "backup.timer" has to
  # be routed to systemd.timers.backup — putting it in systemd.services
  # would silently bind backup.service and leave the timer firing in
  # every trust state.
  unitTypeOptions = {
    service = "services";
    timer = "timers";
    socket = "sockets";
    path = "paths";
  };

  # Every unit type systemd knows. Used to tell a real type suffix apart
  # from a dot inside a unit name (dbus-org.freedesktop.resolve1 must not
  # be read as a ".resolve1" unit). No entry is a suffix of another, so
  # at most one can match.
  allUnitTypes = [
    "service"
    "socket"
    "device"
    "mount"
    "automount"
    "swap"
    "target"
    "path"
    "timer"
    "slice"
    "scope"
  ];

  # "backup.timer" -> { type = "timer"; base = "backup"; optionSet = "timers"; }
  # A name with no recognized type suffix is treated as a service, which
  # is both the previous behaviour and NixOS's own convention for
  # systemd.services attribute names. A unit whose name genuinely ends in
  # another type's suffix can be disambiguated by spelling out .service
  # ("archive.timer.service" -> systemd.services."archive.timer").
  #
  # `bindable` is false for unit types nmtrust cannot bind and for a name
  # that is nothing but a suffix (".timer"). Both are rejected by an
  # assertion and skipped when generating config.
  splitUnitName =
    name:
    let
      matched = builtins.filter (t: lib.hasSuffix ".${t}" name) allUnitTypes;
      type = if matched == [ ] then "service" else builtins.head matched;
      base = if matched == [ ] then name else lib.removeSuffix ".${type}" name;
      optionSet = unitTypeOptions.${type} or null;
    in
    {
      inherit type base optionSet;
      bindable = optionSet != null && base != "";
    };

  bindableUnitTypes = builtins.attrNames unitTypeOptions;

  # States a unit entry resolves to; allowOffline is sugar for adding
  # "offline" to states.
  unitStates = unitCfg: lib.unique (unitCfg.states ++ lib.optional unitCfg.allowOffline "offline");

  # Every binding that names the untrusted state, labelled for error
  # messages. Used to reject the fail-open evalFailurePolicy combination.
  untrustedBoundUnits =
    lib.filter (n: builtins.elem "untrusted" (unitStates cfg.systemUnits.${n})) (
      builtins.attrNames cfg.systemUnits
    )
    ++ lib.concatMap (
      username:
      map (n: "${username}:${n}") (
        lib.filter (n: builtins.elem "untrusted" (unitStates cfg.userUnits.${username}.${n})) (
          builtins.attrNames cfg.userUnits.${username}
        )
      )
    ) userNames;

  # { "backup.timer" = [ states ]; ... }
  #   -> { timers = { backup = [ states ]; }; ... }
  # Two entries can land on the same unit (e.g. "foo" and "foo.service"),
  # so states are unioned rather than overwritten.
  byOptionSet =
    statesByName:
    lib.foldl' (
      acc: unitName:
      let
        u = splitUnitName unitName;
        existing = acc.${u.optionSet} or { };
      in
      if !u.bindable then
        acc
      else
        acc
        // {
          ${u.optionSet} = existing // {
            ${u.base} = lib.unique ((existing.${u.base} or [ ]) ++ statesByName.${unitName});
          };
        }
    ) { } (builtins.attrNames statesByName);

  # systemUnits, grouped by the option set each unit belongs to.
  systemUnitsByOptionSet = byOptionSet (lib.mapAttrs (_: unitStates) cfg.systemUnits);

  # userUnits merged across users first — systemd.user.* is system-wide,
  # so per-user differences in states/allowOffline are resolved by taking
  # the most permissive value (the unit runs in any state some user
  # asked for) — then grouped the same way.
  userUnitsByOptionSet = byOptionSet (
    lib.foldl' (
      acc: username:
      lib.foldl' (
        acc': unitName:
        acc'
        // {
          ${unitName} = lib.unique (
            (acc'.${unitName} or [ ]) ++ unitStates cfg.userUnits.${username}.${unitName}
          );
        }
      ) acc (builtins.attrNames cfg.userUnits.${username})
    ) { } userNames
  );

  # Overrides for one option set, e.g. mkBoundUnits userUnitsByOptionSet "timers"
  mkBoundUnits = grouped: optionSet: lib.mapAttrs (_: mkUnitOverrides) (grouped.${optionSet} or { });

  # Uses StopWhenUnneeded instead of PartOf to avoid same-transaction
  # issues: when transitioning between targets that both want a unit
  # (e.g. offline -> trusted for allowOffline units), PartOf on the
  # old target would stop the unit before WantedBy on the new target
  # can restart it. StopWhenUnneeded only stops the unit when NO
  # active target wants it.
  #
  # wantedBy is mkForce'd for two reasons. Most units worth binding are
  # already `wantedBy = [ "multi-user.target" ]` in the module that
  # defines them; left in place, that keeps the unit "needed" in every
  # trust state and silently reduces the binding to a no-op. Forcing it
  # also means a user's own `wantedBy = lib.mkForce [ ]` merges with this
  # definition at equal priority (list definitions at the winning
  # priority are concatenated) instead of clobbering the trust binding.
  mkUnitOverrides = states: {
    unitConfig.StopWhenUnneeded = true;
    wantedBy = lib.mkForce (map (state: "nmtrust-${state}.target") states);
  };

  # Options shared by systemUnits and userUnits entries.
  unitSubmodule = lib.types.submodule {
    options = {
      states = lib.mkOption {
        type = lib.types.nonEmptyListOf (lib.types.enum trustStates);
        default = [ "trusted" ];
        example = [ "untrusted" ];
        description = ''
          Trust states in which this unit should run. The unit is bound to
          the corresponding `nmtrust-<state>.target`s and stops in every
          state not listed.

          The default `[ "trusted" ]` runs the unit only on trusted
          networks. Use `[ "untrusted" ]` for the inverse case — a unit
          that should run only on networks you do not control, such as a
          VPN or Tailscale bring-up unit. Listing all three states means
          the unit always runs, which makes the binding pointless.
        '';
      };

      allowOffline = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether this unit should also run when offline. Shorthand for
          adding `"offline"` to {option}`states`; the two are unioned.
        '';
      };
    };
  };

  # StopWhenUnneeded= only stops a unit when nothing *active* needs it.
  # Foreign wantedBy is handled by mkForce above, but requiredBy and
  # upheldBy are contributed to other units' Requires=/Upholds= and
  # cannot be overridden from here — they keep the unit running in every
  # trust state and silently reduce the binding to a no-op. Catch them at
  # eval time rather than letting the binding quietly do nothing.
  foreignDeps = unit: lib.subtractLists trustTargetUnits (unit.requiredBy ++ unit.upheldBy);

  mkForeignDepAssertion =
    {
      unit,
      optionPath,
      attrPath,
    }:
    let
      foreign = foreignDeps unit;
    in
    {
      assertion = foreign == [ ];
      message =
        "${optionPath} is also pulled in by ${lib.concatStringsSep ", " foreign} "
        + "via requiredBy/upheldBy. nmtrust stops units with StopWhenUnneeded=, which "
        + "only takes effect when nothing active needs the unit, so it would stay "
        + "running in every trust state and the trust binding would have no effect. "
        + "Clear the other dependency, e.g. ${attrPath}.requiredBy = lib.mkForce [ ]; "
        + "(nmtrust force-overrides wantedBy itself, so plain WantedBy= dependencies "
        + "from other modules need no action).";
    };

  mkUnitNameAssertion =
    { unitName, optionPath }:
    let
      u = splitUnitName unitName;
    in
    if u.base == "" then
      {
        assertion = false;
        message = "${optionPath} has no unit name before the .${u.type} suffix.";
      }
    else
      {
        assertion = u.optionSet != null;
        message =
          "${optionPath} names a .${u.type} unit, which nmtrust cannot bind. "
          + "Only ${lib.concatMapStringsSep ", " (t: ".${t}") bindableUnitTypes} units "
          + "can be bound to a trust target. If this is a service whose name ends in "
          + "\".${u.type}\", spell out the suffix: \"${unitName}.service\".";
      };

  # Assertions for one collection of unit names, resolved against the
  # option set each unit actually belongs to (systemd.timers for a
  # .timer, and so on).
  mkUnitAssertions =
    {
      unitNames,
      optionPathFor,
      systemdPath,
    }:
    lib.concatMap (
      unitName:
      let
        u = splitUnitName unitName;
        optionPath = optionPathFor unitName;
      in
      [ (mkUnitNameAssertion { inherit unitName optionPath; }) ]
      ++ lib.optional u.bindable (mkForeignDepAssertion {
        unit = lib.getAttrFromPath (
          systemdPath
          ++ [
            u.optionSet
            u.base
          ]
        ) config;
        inherit optionPath;
        attrPath = "${lib.concatStringsSep "." systemdPath}.${u.optionSet}.${u.base}";
      })
    ) unitNames;

  # NM dispatcher script
  dispatcherScript = pkgs.writeShellScript "nmtrust-dispatcher" ''
    case "$2" in
      up|down|vpn-up|vpn-down|connectivity-change)
        # A debounce collision ("already exists") is expected -- the pending
        # run evaluates current state, so it covers this event too. Anything
        # else must reach the journal: discarding stderr wholesale made a
        # dispatcher that had stopped scheduling look like a quiet network.
        if ! err=$(${config.systemd.package}/bin/systemd-run \
          --no-block \
          --on-active=1s \
          --unit=nmtrust-apply-debounce \
          ${config.systemd.package}/bin/systemctl start nmtrust-apply.service \
          2>&1); then
          case "$err" in
            *"already exists"*) ;;
            *) echo "nmtrust: could not schedule apply after '$2': $err" >&2 ;;
          esac
        fi
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
        networking.networkmanager.ensureProfiles.
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
        networking.networkmanager.ensureProfiles.
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

        Loopback is always ignored and needs no entry here. A VPN tunnel
        does, so that it cannot feed back into the trust state that
        started it.
      '';
      example = [
        "virbr*"
        "docker*"
        "tailscale0"
      ];
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
        unavailable). "untrusted" (default) is fail-safe: trusted-only
        units stop, and units bound to the untrusted state activate.
        "offline" resolves to the offline state instead, allowing units
        with `allowOffline` to run.

        "offline" is rejected when any unit is bound to the untrusted
        state, because it would stop those units on a failure — dropping
        a VPN while you may still be on an untrusted network.
      '';
    };

    systemUnits = lib.mkOption {
      type = lib.types.attrsOf unitSubmodule;
      default = { };
      example = lib.literalExpression ''
        {
          "my-sync.service" = { };
          "mailsync.timer" = { };
          "backup.service" = { allowOffline = true; };
          "mullvad-connect.service" = { states = [ "untrusted" ]; };
        }
      '';
      description = ''
        System units to bind to the trust targets. Keys are systemd unit
        names; each entry selects the trust states the unit runs in via
        {option}`states` (default `[ "trusted" ]`).

        `.service`, `.timer`, `.socket` and `.path` units are supported,
        and each is routed to the option set that owns it — a
        `"backup.timer"` entry binds `systemd.timers.backup`, not the
        service it triggers. A name with no type suffix is treated as a
        `.service`.
      '';
    };

    userUnits = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf unitSubmodule);
      default = { };
      example = lib.literalExpression ''
        {
          alice = {
            "etesync-dav.service" = { };
            "syncthing.service" = { allowOffline = true; };
            "personal-vpn.service" = { states = [ "untrusted" ]; };
          };
        }
      '';
      description = ''
        Per-user units to bind to the trust targets.
        Outer keys are usernames, inner keys are systemd unit names.
        Users must have linger enabled (users.users.<name>.linger = true).
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
        # evalFailurePolicy = "offline" is fail-open for untrusted-bound units
        [
          {
            assertion = cfg.evalFailurePolicy != "offline" || untrustedBoundUnits == [ ];
            message =
              "services.nmtrust.evalFailurePolicy = \"offline\" cannot be combined with "
              + "units bound to the untrusted state (${lib.concatStringsSep ", " untrustedBoundUnits}). "
              + "On an evaluation failure the offline policy resolves to the offline state, "
              + "which stops untrusted-bound units — so a transient D-Bus error would drop a "
              + "VPN while you may still be on an untrusted network. That is fail-open, and "
              + "it is the opposite of why the unit is bound to untrusted in the first place. "
              + "Use the default evalFailurePolicy = \"untrusted\", which activates those units "
              + "on failure instead.";
          }
        ]
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
        }) (builtins.filter (u: config.users.users ? ${u}) userNames))
      ++
        # systemUnits -> bindable unit type, and no foreign dependency
        # defeating StopWhenUnneeded
        (mkUnitAssertions {
          unitNames = builtins.attrNames cfg.systemUnits;
          optionPathFor = unitName: "services.nmtrust.systemUnits.\"${unitName}\"";
          systemdPath = [ "systemd" ];
        })
      ++
        # userUnits -> same checks, deduplicated across users
        (mkUnitAssertions {
          unitNames = sharedUserUnitNames;
          optionPathFor = unitName: "services.nmtrust.userUnits.*.\"${unitName}\"";
          systemdPath = [
            "systemd"
            "user"
          ];
        });

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

    # Each bound unit is routed to the option set that owns its type;
    # NixOS appends the type suffix back on.
    systemd.timers = mkBoundUnits systemUnitsByOptionSet "timers";
    systemd.sockets = mkBoundUnits systemUnitsByOptionSet "sockets";
    systemd.paths = mkBoundUnits systemUnitsByOptionSet "paths";

    systemd.services = mkBoundUnits systemUnitsByOptionSet "services" // {
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

    systemd.user.services = mkBoundUnits userUnitsByOptionSet "services";
    systemd.user.timers = mkBoundUnits userUnitsByOptionSet "timers";
    systemd.user.sockets = mkBoundUnits userUnitsByOptionSet "sockets";
    systemd.user.paths = mkBoundUnits userUnitsByOptionSet "paths";

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
