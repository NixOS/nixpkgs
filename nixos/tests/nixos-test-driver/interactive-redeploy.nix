{
  expect,
  runCommand,
  testers,
  writeScript,
}:
let
  test0 = testers.runNixOSTest {
    name = "test-nixos-test-driver-interactive-redeploy-0";
    nodes.machine =
      { config, pkgs, ... }:
      {
        environment.etc."custom-test-marker".text = "test-0";
      };
    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("[[ $(cat /etc/custom-test-marker | tee /dev/stderr) == test-0 ]]")
    '';
  };
  test1 = testers.runNixOSTest {
    name = "test-nixos-test-driver-interactive-redeploy-1";
    nodes.machine =
      { config, pkgs, ... }:
      {
        environment.etc."custom-test-marker".text = "test-1";
      };
    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("[[ $(cat /etc/custom-test-marker | tee /dev/stderr) == test-1 ]]")
    '';
  };
in
runCommand "test-nixos-test-driver-interactive-redeploy"
  {
    requiredSystemFeatures = [
      "nixos-test"
      "kvm"
    ];
    nativeBuildInputs = [ expect ];
    passthru = {
      inherit test0 test1;
    };
    expectScript = writeScript "test-nixos-test-driver-interactive-redeploy.expect" ''
      proc log_header {message} {
        send_user "\n================================================\n"
        send_user "  $message\n"
        send_user "================================================\n"
      }

      log_header "STARTING INTERACTIVE TEST DRIVER"

      spawn ./result/bin/nixos-test-driver
      log_user 1
      set timeout 60

      set test_script_sent 0

      expect {
        ">>>" {
          log_header "STARTING TEST SCRIPT (test0)"
          send "test_script()\r"
        }
        "Traceback" { puts "test-nixos-test-driver-interactive-redeploy unexpected error"; exit 1 }
        default { puts "unexpected output"; exit 1 }
        timeout { puts "test-nixos-test-driver-interactive-redeploy timed out while waiting for prompt"; exit 1 }
      }

      expect {
        "finished: run the VM test script" {
        }
        "Traceback" { puts "test-nixos-test-driver-interactive-redeploy unexpected error"; exit 1 }
        timeout { puts "test-nixos-test-driver-interactive-redeploy timed out while waiting for test_script()"; exit 1 }
      }

      log_header "REDEPLOYING"

      # Docs example: nix-build . -A nixosTests.login.driverInteractive
      send "rebuild(\"rm result; mv test1 result\")\r"

      expect {
        "finished: updating machines" { }
        "Traceback" { puts "test-nixos-test-driver-interactive-redeploy unexpected error"; exit 1 }
        timeout { puts "test-nixos-test-driver-interactive-redeploy timed out while waiting for rebuild()"; exit 1 }
      }

      log_header "STARTING TEST SCRIPT (test1)"

      send "test_script()\r"

      expect {
        "== test-1" { }
        "Traceback" { puts "test-nixos-test-driver-interactive-redeploy unexpected error"; exit 1 }
        timeout { puts "test-nixos-test-driver-interactive-redeploy timed out while waiting for test output"; exit 1 }
      }

      expect {
        "finished: run the VM test script" {
        }
        "Traceback" { puts "test-nixos-test-driver-interactive-redeploy unexpected error"; exit 1 }
        timeout { puts "test-nixos-test-driver-interactive-redeploy timed out while waiting for test_script()"; exit 1 }
      }

      log_header "EXITING"

      send "exit\r"

      expect {
        eof { }
        default { exp_continue }
        timeout { puts "test-nixos-test-driver-interactive-redeploy timed out while waiting for exit"; exit 1 }
      }

      log_header "PASSED"
    '';
  }
  ''
    ln -s ${test0.driverInteractive} result
    ln -s ${test1.driverInteractive} test1
    expect $expectScript
    touch $out
  ''
