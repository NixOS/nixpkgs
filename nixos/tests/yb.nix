{
  lib,
  pkgs,
  ybPivHarnessTests,
  testFixtures,
}:

pkgs.testers.nixosTest {
  name = "yb-integration-tests";
  meta.maintainers = with lib.maintainers; [ douzebis ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.pcscd = {
        enable = true;
        plugins = [
          pkgs.ccid
          pkgs.vsmartcard-vpcd
        ];
      };

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
    # concurrent vpcd connections.
    out = machine.succeed("RUST_TEST_THREADS=1 hardware_piv_tests 2>&1")
    print(out)
    if "test result: ok" not in out:
      raise Exception("hardware_piv_tests failed:\n" + out)

    # Tier-2: CLI subprocess tests against the Nix-built yb binary.
    # YB_FIXTURE_DIR points to fixtures in the nix store (the build-sandbox
    # path baked into CARGO_MANIFEST_DIR is gone at VM runtime).
    out = machine.succeed(
      "RUST_TEST_THREADS=1"
      + " YB_BIN=${pkgs.yb}/bin/yb"
      + " YB_FIXTURE_DIR=${testFixtures}"
      + " yb_cli_tests 2>&1"
    )
    print(out)
    if "test result: ok" not in out:
      raise Exception("yb_cli_tests failed:\n" + out)
  '';
}
