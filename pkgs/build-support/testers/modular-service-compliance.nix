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
    };
  };

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
    };

  conflictEval = evalConfig {
    services = {
      conflict = {
        process.argv = [ "${coreutils}/bin/true" ];
        process.reloadSignal = "HUP";
        process.reloadCommand = "${coreutils}/bin/kill -HUP $MAINPID";
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

  # See also the manual compliance items in doc/build-helpers/testers.chapter.md.
}
