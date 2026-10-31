{
  lib,
  coreutils,
  gnugrep,
  writeShellScript,
  writeShellApplication,
  stdenvNoCC,
}:

/**
  See https://nixos.org/manual/nixpkgs/unstable/#tester-modularServiceCompliance
  or doc/build-helpers/testers.chapter.md
*/
{
  evalConfig,
  mkTest,
  sharedDir,
  callReload,
  namePrefix ? "modular-service-compliance",
}:

let

  /**
    The identity requests exercised by the identity compliance checks: every
    portable identity option pinned at once. Eval-level only; never deployed,
    so the pinned ids need not be free on the target platform.
  */
  identityRequests = {
    user = "compliance-user";
    uid = 1400;
    group = "compliance-group";
    gid = 1401;
    groups = [ "compliance-supp" ];
    gids = [ 1402 ];
  };

  /**
    A composite service exercising `identity.sameUser`: the anchor pins a user
    name, `shared` references it without further requests, and `weak`
    references it while also requesting a user, which must take precedence
    over the reference while unset values still come from it. `argvFor` builds
    the ExecStart argv for each service (which does not affect the
    resolution).
  */
  identityTree =
    argvFor:
    { config, ... }:
    {
      process.argv = argvFor "identity-test";
      services.anchor = {
        process.argv = argvFor "identity-anchor";
        identity.user = "compliance-anchor";
      };
      services.shared = {
        process.argv = argvFor "identity-shared";
        identity.sameUser = config.services.anchor;
      };
      services.weak = {
        process.argv = argvFor "identity-weak";
        identity.sameUser = config.services.anchor;
        identity.user = "compliance-override";
      };
    };

  /**
    A successful evaluation to be probed by evalTestDefs
  */
  # Try use only few evalConfig calls for performance.
  evalResult = evalConfig {
    services = {
      svc = {
        process.argv = [ "${coreutils}/bin/true" ];
        assertions = [
          {
            assertion = true;
            message = "compliance test assertion";
          }
        ];
        warnings = [ "compliance test warning" ];
        services.child = {
          process.argv = [ "${coreutils}/bin/true" ];
          assertions = [
            {
              assertion = true;
              message = "compliance child assertion";
            }
          ];
          warnings = [ "compliance child warning" ];
        };
        # A sub-service exercising reload derivation from a reload signal.
        services.reloadee = {
          process.argv = [ "${coreutils}/bin/true" ];
          process.reloadSignal = "HUP";
        };
      };

      # Services exercising the identity (user/group) contract.
      identity-plain.process.argv = [ "${coreutils}/bin/true" ];
      identity-pinned = {
        process.argv = [ "${coreutils}/bin/true" ];
        identity = identityRequests;
      };
      identity-test = identityTree (_: [ "${coreutils}/bin/true" ]);
    };
  };

  /**
    Whether the integration supports user accounts, probed by reading the
    resolved identity of a service that makes no requests: the portable
    contract gives a user name derived from the attribute path on
    user-supporting platforms, and `null` on platforms without user support.
    An integration that does not resolve identities at all also probes as
    unsupported here, and is caught by testIdentityUnsupportedNull.
  */
  userSupport =
    let
      svc = evalResult.config.identity-plain or { };
      v = if svc ? identity then svc.identity.user else null;
    in
    (builtins.tryEval v).success && v != null;

  /**
    Shell-ish snippet wrapper for eval-level checks: a `throw`-based evaluation
    failure counts as a violation, reported as a named FAIL instead of a raw
    eval error. Missing attributes are not `throw`-based; guard such selects
    with `?` instead.
  */
  holds = v: (builtins.tryEval v).success && v;

  identityEvalTestDefs =
    let
      c = evalResult.config;
    in
    {
      # The service manager injects the built-in, read-only
      # `absoluteServicePath` on every service: the tag that makes a service
      # configuration referenceable by `identity.sameUser`. Its value is the
      # service's attribute path, as a list of attribute names.
      testIdentityHandleTopLevel = {
        expr = holds (
          c.identity-plain ? absoluteServicePath
          && c.identity-plain.absoluteServicePath == [ "identity-plain" ]
        );
        expected = true;
      };

      testIdentityHandleSubService = {
        expr = holds (
          c.identity-test ? services
          && c.identity-test.services ? anchor
          &&
            c.identity-test.services.anchor.absoluteServicePath == [
              "identity-test"
              "anchor"
            ]
        );
        expected = true;
      };
    }
    // (
      if userSupport then
        {
          # Default resolution: the service runs as its own user, whose name
          # is derived from the attribute path (the exact derivation is
          # integration-specific), with a user-private group named after the
          # user; ids are left to the platform, and there are no supplementary
          # groups.
          testIdentityDefaultUser = {
            expr = holds (
              c.identity-plain.identity.user != null && c.identity-plain.identity.user != c.svc.identity.user
            );
            expected = true;
          };

          testIdentityDefaultGroup = {
            expr = holds (c.identity-plain.identity.group == c.identity-plain.identity.user);
            expected = true;
          };

          testIdentityDefaultIdless = {
            expr = holds (c.identity-plain.identity.uid == null && c.identity-plain.identity.gid == null);
            expected = true;
          };

          testIdentityDefaultNoSupplementary = {
            expr = holds (c.identity-plain.identity.groups == [ ] && c.identity-plain.identity.gids == [ ]);
            expected = true;
          };

          # Requests are resolved to exactly the requested values.
          testIdentityRequestsHonored = {
            expr = holds (builtins.removeAttrs c.identity-pinned.identity [ "sameUser" ] == identityRequests);
            expected = true;
          };

          # `identity.sameUser`: the referencing service resolves to the
          # referenced service's resolved identity.
          testIdentitySameUser = {
            expr = holds (
              c.identity-test.services.shared.identity.user == c.identity-test.services.anchor.identity.user
              && c.identity-test.services.shared.identity.group == c.identity-test.services.anchor.identity.group
            );
            expected = true;
          };

          # Unset requests come from the reference (the anchor pins no uid).
          testIdentitySameUserUidFromRef = {
            expr = holds (
              c.identity-test.services.shared.identity.uid == c.identity-test.services.anchor.identity.uid
            );
            expected = true;
          };

          # Options set on the referencing service take precedence over the
          # reference; unset ones still come from it.
          testIdentitySameUserPrecedence = {
            expr = holds (
              c.identity-test.services.weak.identity.user == "compliance-override"
              && c.identity-test.services.weak.identity.group == c.identity-test.services.anchor.identity.user
            );
            expected = true;
          };

          # `identity.gids` must be empty or pair positionally with
          # `identity.groups`. The constraint is enforced when the evaluation
          # fails, or when a failing assertion is collected on the service.
          testIdentityGidsGroupsEnforced = {
            expr =
              let
                outcome = builtins.tryEval (conflictEval.config.identity-gids-mismatch or { });
              in
              if !outcome.success then
                # The evaluation fails on the mismatch: enforced.
                true
              else
                outcome.value ? assertions && lib.any (a: !a.assertion) outcome.value.assertions;
            expected = true;
          };
        }
      else
        {
          # Without user support, every value resolves to `null`, even
          # explicit requests.
          testIdentityUnsupportedNull = {
            expr = holds (
              c.identity-pinned ? identity
              &&
                c.identity-pinned.identity == {
                  user = null;
                  uid = null;
                  group = null;
                  gid = null;
                  groups = null;
                  gids = null;
                  sameUser = null;
                }
            );
            expected = true;
          };
        }
    );

  evalTestDefs =
    let
      c = evalResult.config.svc;
    in
    {
      testProcessArgv = {
        expr = c.process.argv;
        expected = [ "${coreutils}/bin/true" ];
      };

      testSubServiceArgv = {
        expr = c.services.child.process.argv;
        expected = [ "${coreutils}/bin/true" ];
      };

      testAssertions = {
        expr = lib.elem {
          assertion = true;
          message = "compliance test assertion";
        } c.assertions;
        expected = true;
      };

      testWarnings = {
        expr = lib.elem "compliance test warning" c.warnings;
        expected = true;
      };

      testSubServiceAssertions = {
        expr = lib.elem {
          assertion = true;
          message = "compliance child assertion";
        } c.services.child.assertions;
        expected = true;
      };

      testSubServiceWarnings = {
        expr = lib.elem "compliance child warning" c.services.child.warnings;
        expected = true;
      };

      # The reload-conflict assertion must not fire (its `assertion` must hold) for a
      # service that sets only reloadSignal (guards the inverted-assertion fix, and the
      # priority-aware conflict detection: reloadSignal derives reloadCommand internally,
      # which must not be mistaken for a user-set conflict).
      testNoReloadConflict = {
        expr = lib.any (
          a:
          a.message
          == "reloadSignal conflicts with reloadCommand. Please either use reloadSignal or reloadCommand."
          && !a.assertion
        ) c.services.reloadee.assertions;
        expected = false;
      };

      # Setting process.reloadSignal derives process.reloadCommand
      # (guards the misplaced-paren mkIf fix).
      testReloadSignalDerivesCommand = {
        expr = c.services.reloadee.process.reloadCommand;
        expected = "${coreutils}/bin/kill -HUP $MAINPID";
      };

      # notificationProtocol submodule bools default to false.
      testNotificationProtocolSystemdDefault = {
        expr = c.notificationProtocol.systemd;
        expected = false;
      };

      testNotificationProtocolS6Default = {
        expr = c.notificationProtocol.s6;
        expected = false;
      };

      # Setting both reloadSignal and reloadCommand explicitly is a genuine conflict,
      # so the assertion must fire. Separate eval: checkDrv would fail on this.
      testReloadConflictFires = {
        expr = lib.any (
          a:
          a.message
          == "reloadSignal conflicts with reloadCommand. Please either use reloadSignal or reloadCommand."
          && !a.assertion
        ) conflictEval.config.conflict.assertions;
        expected = true;
      };

      # Separate eval for a failing assertion — checkDrv would fail here,
      # so we only access config.
      testFailingAssertionValue = {
        expr = lib.elem {
          assertion = false;
          message = "compliance failing assertion";
        } failingEval.config.failing.assertions;
        expected = true;
      };
    }
    // identityEvalTestDefs;

  conflictEval = evalConfig {
    services = {
      conflict = {
        process.argv = [ "${coreutils}/bin/true" ];
        process.reloadSignal = "HUP";
        process.reloadCommand = "${coreutils}/bin/kill -HUP $MAINPID";
      };

      # `identity.gids` without `identity.groups`: the mismatch must be
      # enforced, not silently ignored. checkDrv is never built for this eval.
      identity-gids-mismatch = {
        process.argv = [ "${coreutils}/bin/true" ];
        identity.gids = [ 1522 ];
      };
    };
  };

  failingEval = evalConfig {
    services = {
      failing = {
        process.argv = [ "${coreutils}/bin/true" ];
        assertions = [
          {
            assertion = false;
            message = "compliance failing assertion";
          }
        ];
      };
    };
  };

  /**
    A service script that records its received arguments, then sleeps forever.
    The first argument is a service identifier used to namespace its comms
    subdirectory; the remaining arguments are recorded as the service's args.
  */
  svc = writeShellScript "${namePrefix}-svc" ''
    id="$1"; shift
    dir="${sharedDir}/$id"
    mkdir -p "$dir"
    echo "$$" > "$dir/pid"
    printf '%s\n' "$@" > "$dir/args"
    exec "${coreutils}/bin/sleep" infinity
  '';

  /**
    A reloadable service script. Like `svc`, it namespaces a comms subdirectory
    by its first argument and records the remaining arguments. It traps SIGHUP
    and appends a marker line to `$dir/reloads` on each reload, then stays alive
    as the trapping shell itself (no `exec`, so the trap and MAINPID are kept).
  */
  reloadableSvc = writeShellScript "${namePrefix}-reloadable-svc" ''
    id="$1"; shift
    dir="${sharedDir}/$id"
    mkdir -p "$dir"
    : > "$dir/reloads"
    reload() { printf 'reloaded\n' >> "$dir/reloads"; }
    trap reload HUP
    echo "$$" > "$dir/pid"
    printf '%s\n' "$@" > "$dir/args"
    while true; do "${coreutils}/bin/sleep" 1; done
  '';

  /**
    A service script that records the user and group it actually runs as, next
    to its pid, then sleeps forever. Used by the identity integration test;
    `${sharedDir}` must be writable by the service's user. The pid file is
    written last, marking the identity as recorded.
  */
  identitySvc = writeShellScript "${namePrefix}-identity-svc" ''
    id="$1"; shift
    dir="${sharedDir}/$id"
    mkdir -p "$dir"
    ${coreutils}/bin/id -un > "$dir/own-user"
    ${coreutils}/bin/id -gn > "$dir/own-group"
    echo "$$" > "$dir/pid"
    exec "${coreutils}/bin/sleep" infinity
  '';

  mkArgv =
    id: extraArgs:
    [
      svc
      id
    ]
    ++ extraArgs;

  /**
    Shell snippet: wait for a service to write its pid file, verify the
    process is still alive, then check that each expected argument appears
    in the recorded args file.
  */
  waitAndCheck =
    id: expectedArgs:
    ''
      echo "waiting for ${id}..."
      timeout=30; elapsed=0
      while [ ! -f "${sharedDir}/${id}/pid" ] && [ "$elapsed" -lt "$timeout" ]; do
        sleep 1; elapsed=$((elapsed + 1))
      done
      test -f "${sharedDir}/${id}/pid" || { echo "${id}: no pid file after ''${timeout}s"; exit 1; }
      pid=$(cat "${sharedDir}/${id}/pid")
      kill -0 "$pid" || { echo "${id}: pid $pid is not running"; exit 1; }
      echo "${id}: started (pid $pid)"
    ''
    + lib.concatMapStrings (arg: ''
      grep -qxF -- ${lib.escapeShellArg arg} "${sharedDir}/${id}/args" \
        || { echo "${id}: expected arg ${lib.escapeShellArg arg} not found"; cat "${sharedDir}/${id}/args"; exit 1; }
    '') expectedArgs;

  mkTestScript =
    name: text:
    lib.getExe (writeShellApplication {
      name = "${namePrefix}-${name}";
      runtimeInputs = [
        coreutils
        gnugrep
      ];
      inherit text;
    });

  /**
    The identity of the identityTree services, as resolved by the
    integration: the expectations of the identity integration test.
  */
  identityResolved = evalResult.config.identity-test;

  /**
    Shell snippet: wait for a service to start, then check that it records
    itself as running as the given resolved user and group.
  */
  checkOwnIdentity =
    id: expectedUser: expectedGroup:
    waitAndCheck id [ ]
    + ''
      ownUser="$(cat "${sharedDir}/${id}/own-user")"
      test "$ownUser" = ${lib.escapeShellArg expectedUser} \
        || { echo "${id}: runs as user $ownUser, expected ${expectedUser}"; exit 1; }
      ownGroup="$(cat "${sharedDir}/${id}/own-group")"
      test "$ownGroup" = ${lib.escapeShellArg expectedGroup} \
        || { echo "${id}: runs as group $ownGroup, expected ${expectedGroup}"; exit 1; }
      echo "${id}: runs as ${expectedUser}:${expectedGroup}"
    '';

  # The reload runtime test's service tree. The reloadable unit is the *sub*-service,
  # so its name path `[ "reload" "inner" ]` handed to `callReload` exercises the
  # integration's nested unit naming (NixOS dash-joins to `reload-inner.service`).
  reloadServices = {
    reload = {
      # Parent must run something; a bare keep-alive is enough.
      process.argv = [
        reloadableSvc
        "reload-parent"
      ];
      services.inner.process = {
        argv = [
          reloadableSvc
          "reload-inner"
        ];
        # The script traps SIGHUP; reloadSignal derives the manager's reload command.
        reloadSignal = "HUP";
      };
    };
  };

in
{
  # Eval-level tests: config structure, evaluated in the integration's
  # full context (one whole-system eval).
  # TODO: generalize with
  #   - pkgs/test/buildenv.nix
  #   - pkgs/test/overriding.nix
  eval = stdenvNoCC.mkDerivation (finalAttrs: {
    __structuredAttrs = true;
    name = "${namePrefix}-eval-report";
    # Depend on the integration's representative derivation to prove that
    # the system builds with these services.
    representative = evalResult.checkDrv;
    passthru = {
      tests = evalTestDefs;
      failures = lib.runTests finalAttrs.finalPackage.tests;
    };
    testResults = lib.mapAttrs (_: test: test.expr == test.expected) finalAttrs.finalPackage.tests;
    buildCommand = ''
      touch $out
      for testName in "''${!testResults[@]}"; do
        if [[ -n "''${testResults[$testName]}" ]]; then
          echo "PASS  $testName"
        else
          echo "FAIL  $testName"
        fi
      done
    ''
    + lib.optionalString (lib.any (v: !v) (lib.attrValues finalAttrs.testResults)) ''
      {
        echo ""
        echo "Eval-level compliance failures:"
        for testName in "''${!testResults[@]}"; do
          if [[ -z "''${testResults[$testName]}" ]]; then
            echo "- $testName"
          fi
        done
        echo ""
        echo 'Inspect with: nix eval .#<path>.tests.''${testName}'
      } >&2
      exit 1
    '';
  });

  # Integration tests: verify that services actually run.

  basic-argv = mkTest {
    name = "${namePrefix}-basic-argv";
    services.test.process.argv = mkArgv "test" [
      "--greeting"
      "hello"
    ];
    testExe = mkTestScript "basic-argv" (
      waitAndCheck "test" [
        "--greeting"
        "hello"
      ]
    );
  };

  sub-services = mkTest {
    name = "${namePrefix}-sub-services";
    services.a = {
      process.argv = mkArgv "a" [ "--depth=0" ];
      services.b = {
        process.argv = mkArgv "b" [ "--depth=1" ];
        services.c.process.argv = mkArgv "c" [ "--depth=2" ];
      };
    };
    testExe = mkTestScript "sub-services" ''
      ${waitAndCheck "a" [ "--depth=0" ]}
      ${waitAndCheck "b" [ "--depth=1" ]}
      ${waitAndCheck "c" [ "--depth=2" ]}
    '';
  };

  # Runtime reload: start a reloadable service, ask the integration to reload it,
  # and assert the service observed the reload (recorded a SIGHUP marker).
  reload = mkTest {
    name = "${namePrefix}-reload";
    services = reloadServices;
    testExe = mkTestScript "reload" ''
      ${waitAndCheck "reload-inner" [ ]}
      ${callReload [
        "reload"
        "inner"
      ]}
      timeout=30; elapsed=0
      while ! grep -qx "reloaded" "${sharedDir}/reload-inner/reloads" && [ "$elapsed" -lt "$timeout" ]; do
        sleep 1; elapsed=$((elapsed + 1))
      done
      grep -qx "reloaded" "${sharedDir}/reload-inner/reloads" \
        || { echo "reload: no reload recorded after ''${timeout}s"; cat "${sharedDir}/reload-inner/reloads"; exit 1; }
      echo "reload: reload observed"
    '';
  };
}
// lib.optionalAttrs userSupport {
  # Identity: the services actually run as the resolved identity. Not
  # meaningful on platforms without user support, where all identity values
  # resolve to `null`.
  identity = mkTest {
    name = "${namePrefix}-identity";
    services = {
      identity-test = identityTree (id: [
        identitySvc
        id
      ]);
    };
    testExe = mkTestScript "identity" (
      checkOwnIdentity "identity-test" identityResolved.identity.user identityResolved.identity.group
      +
        checkOwnIdentity "identity-anchor" identityResolved.services.anchor.identity.user
          identityResolved.services.anchor.identity.group
      +
        checkOwnIdentity "identity-shared" identityResolved.services.shared.identity.user
          identityResolved.services.shared.identity.group
      +
        checkOwnIdentity "identity-weak" identityResolved.services.weak.identity.user
          identityResolved.services.weak.identity.group
    );
  };

  # See also the manual compliance items in doc/build-helpers/testers.chapter.md.
}
