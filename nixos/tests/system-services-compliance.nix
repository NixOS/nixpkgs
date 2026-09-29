{
  pkgs,
  evalSystem,
  runTest,
  callTest,
}:

let
  sharedDir = "/tmp/modular-service-compliance";

  inherit (pkgs) lib coreutils;

  evalSystemServices =
    services:
    evalSystem (
      { ... }:
      {
        system.services = services;
        system.stateVersion = "25.05";
        fileSystems."/" = {
          device = "/test/dummy";
          fsType = "auto";
        };
        boot.loader.grub.enable = false;
      }
    );
in
let
  suite = pkgs.testers.modularServiceCompliance {
    inherit sharedDir;
    namePrefix = "system-services-compliance";
    evalConfig =
      { services }:
      let
        machine = evalSystemServices services;
      in
      {
        config = machine.config.system.services;
        checkDrv = machine.config.system.build.toplevel;
      };
    callReload = path: "systemctl reload ${lib.concatStringsSep "-" path}.service";
    mkTest =
      {
        name,
        services,
        testExe,
      }:
      runTest {
        _class = "nixosTest";
        inherit name;
        nodes.machine.system.services = services;
        testScript = ''
          machine.wait_for_unit("multi-user.target")
          machine.succeed("${testExe}")
        '';
        meta.maintainers = with pkgs.lib.maintainers; [ roberth ];
      };
  };

  # systemd-specific eval assertions. serviceConfig.Type/ExecReload only exist on
  # the resolved host units, so a fresh eval is used per case.
  systemdEvalTests =
    let
      defaultUnits =
        (evalSystemServices {
          service.process.argv = [ "${coreutils}/bin/true" ];
        }).config.systemd.services;

      notifyUnits =
        (evalSystemServices {
          service = {
            process.argv = [ "${coreutils}/bin/true" ];
            notificationProtocol.systemd = true;
          };
        }).config.systemd.services;

      reloadUnits =
        (evalSystemServices {
          service = {
            process.argv = [ "${coreutils}/bin/true" ];
            process.reloadSignal = "HUP";
          };
        }).config.systemd.services;

      # A service setting `ExecReload` through the systemd escape hatch, without
      # any `process.reloadCommand` of its own.
      ownExecReloadUnits =
        (evalSystemServices {
          service = {
            process.argv = [ "${coreutils}/bin/true" ];
            systemd.service.serviceConfig.ExecReload = "${coreutils}/bin/kill -USR2 $MAINPID";
          };
        }).config.systemd.services;
    in
    {
      testDefaultType = {
        expr = defaultUnits.service.serviceConfig.Type;
        expected = "simple";
      };

      testNotifyType = {
        expr = notifyUnits.service.serviceConfig.Type;
        expected = "notify";
      };

      testReloadExecReload = {
        expr = reloadUnits.service.serviceConfig.ExecReload;
        expected = "${coreutils}/bin/kill -HUP $MAINPID";
      };

      # Without a reload command, the framework must not define `ExecReload` at
      # all, so that it neither conflicts with a service-provided definition nor
      # renders a bare `ExecReload=` line.
      testNoReloadExecReloadUnset = {
        expr = defaultUnits.service.serviceConfig ? ExecReload;
        expected = false;
      };

      testServiceOwnExecReload = {
        expr = ownExecReloadUnits.service.serviceConfig.ExecReload;
        expected = "${coreutils}/bin/kill -USR2 $MAINPID";
      };
    };

  systemdEval = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    __structuredAttrs = true;
    name = "system-services-compliance-systemd-eval-report";
    passthru = {
      tests = systemdEvalTests;
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
        echo "systemd-specific eval-level compliance failures:"
        for testName in "''${!testResults[@]}"; do
          if [[ -z "''${testResults[$testName]}" ]]; then
            echo "- $testName"
          fi
        done
      } >&2
      exit 1
    '';
  });
in

# Please the callTest pattern.
#
# runTest results already go through findTests/callTest.
# For plain derivations like `eval`, we apply callTest directly.
pkgs.lib.mapAttrs (
  _: v:
  if v ? test then
    v
  else
    callTest {
      test = v;
      driver = v;
    }
) (suite // { systemd-eval = systemdEval; })
