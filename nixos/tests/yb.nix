{
  lib,
  pkgs,
  ybPivHarnessTests,
}:

pkgs.testers.nixosTest {
  name = "yb-integration-tests";
  meta.maintainers = with lib.maintainers; [ douzebis ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.pcscd.enable = true;
      # The virtual reader driver the PIV tests connect their emulated card to.
      services.vsmartcard-vpcd.enable = true;

      environment.systemPackages = [
        pkgs.yb
        ybPivHarnessTests
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("pcscd.socket")

    # Tier-2: virtual smart card PIV tests (each test gets a fresh
    # RAM-backed card via vsmartcard-vpcd). Serialised to avoid
    # concurrent vpcd connections. YB_REQUIRE_VSC makes a missing vpcd a
    # failure instead of a skip.
    out = machine.succeed("YB_REQUIRE_VSC=1 hardware_piv_tests --test-threads=1 2>&1")
    print(out)
    if "test result: ok" not in out:
      raise Exception("hardware_piv_tests failed:\n" + out)

    # The packaged yb ignores YB_FIXTURE: a nonexistent file is not read.
    machine.succeed("YB_FIXTURE=/nonexistent yb list-readers")

    # Tier-2: CLI subprocess tests against a yb built, from the same source,
    # with the test-fixture feature, which honors YB_FIXTURE.
    out = machine.succeed(
      "YB_BIN=${ybPivHarnessTests}/libexec/yb-test-fixture yb_cli_tests --test-threads=1 2>&1"
    )
    print(out)
    if "test result: ok" not in out:
      raise Exception("yb_cli_tests failed:\n" + out)
  '';
}
