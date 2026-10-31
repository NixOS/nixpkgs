{
  config,
  ...
}:
let
  cfg = config.test-tpm2-totp;
in
{

  _class = "nixosTest";

  imports = [
    ./_common.nix
  ];

  name = "tpm2-totp-plymouth";

  # to verify TOTP digits on the plymouth screen
  enableOCR = true;

  nodes.machine =
    { config, ... }:
    {

      # minimal enablement of tpm2-totp module
      boot = {
        initrd.systemd.enable = true;
        plymouth = {
          enable = true;
          tpm2-totp.enable = true;
        };
      };

      # required for manual TOTP calculation in initrd by testScript
      boot.initrd.systemd.extraBin.tpm2-totp = "${config.boot.plymouth.tpm2-totp.package}/bin/tpm2-totp";

      # pause boot for test inspection
      testing.initrdBackdoor = true;

    };

  testScript = ''
    import re

    # required for later reboot
    machine.start(allow_reboot=True)

    with subtest("mirror typical tpm2-totp setup flow"):
      machine.wait_for_unit("initrd.target")
      machine.switch_root()
      machine.wait_for_unit("multi-user.target")
      # seal without password for recovery should also work
      machine.succeed("tpm2-totp ${cfg.sealArgs} generate")

    with subtest("reboot into initrd"):
      machine.reboot()
      machine.wait_for_unit("initrd.target")

    with subtest("plymouth-tpm2-totp.service runs in initrd"):
      machine.wait_for_unit("plymouth-tpm2-totp.service")
      machine.succeed("systemctl is-active plymouth-tpm2-totp.service")

    with subtest("TOTP can be calculated in initrd"):
      out = machine.succeed("tpm2-totp calculate").strip()
      assert re.search(r"^\d{6}$", out), f"no 6-digit TOTP found in: {out!r}"

    with subtest("plymouth displays TOTP digits on the screen"):
      # not match against exact expected TOTP as may have already changed by the time OCR was successful
      machine.wait_for_text(r"\d{6}")

    with subtest("confirm full boot still works"): # test just in case
      machine.switch_root()
      machine.wait_for_unit("multi-user.target")
  '';

}
