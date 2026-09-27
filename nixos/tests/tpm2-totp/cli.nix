{
  config,
  lib,
  ...
}:
let
  inherit (builtins) head;
  inherit (lib.strings)
    escapeShellArgs
    replicate
    toLower
    ;

  cfg = config.test-tpm2-totp;

  # extend a used PCR to invalidate the TOTP
  pcrExtendCmd =
    let
      bank = head cfg.banks;
      pcr = head cfg.pcrs;
      bankLength = cfg.bankToHexLength.${bank};
    in
    escapeShellArgs [
      "tpm2_pcrextend"
      "${pcr}:${toLower bank}=${replicate bankLength "0"}"
    ];

  totpPassword = "-P abcdef";
  totpInvalidPassword = "-P wrong";
in
{

  _class = "nixosTest";

  imports = [
    ./_common.nix
  ];

  name = "tpm2-totp-cli";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        tpm2-tools # for tpm2_pcrextend
        tpm2-totp # manually test the CLI commands (without using module)
        oath-toolkit # for oathtool, to independently verify the TOTP
      ];
    };

  testScript = ''
    import re

    def extract_secret(out: str) -> str:
      """extract TOTP secret from tpm2-totp output"""
      url = next(l for l in out.splitlines() if l.startswith("otpauth://"))
      return url.split("secret=")[1]

    # wait for systemd finished booting, otherwise PCRs might still change
    machine.wait_for_unit("multi-user.target")

    with subtest("calculate fails when no secret is stored"):
      machine.fail("tpm2-totp calculate")

    with subtest("typical tpm2-totp setup flow"):
      out = machine.succeed("tpm2-totp ${totpPassword} ${cfg.sealArgs} generate")
      secret = extract_secret(out)
      print(f"secret: {secret!r}")

    with subtest("calculate produces a TOTP that matches oathtool"):
      totp = machine.succeed("tpm2-totp calculate").strip()
      # check ±30s step to avoid flakiness around step boundaries
      now = int(machine.succeed("date +%s").strip())
      codes = []
      for offset in (-30, 0, 30):
        t = machine.succeed(f"date -d @{now + offset} +%Y-%m-%dT%H:%M:%S").strip()
        code = machine.succeed(f"oathtool --totp --base32 --now {t} {secret}").strip()
        codes.append(code)
      assert totp in codes, f"{totp} not in {codes!r} at epoch {now!r}"

    with subtest("calculate with --time prints the calculation time"):
      out = machine.succeed("tpm2-totp -t calculate").strip()
      assert re.search(r"^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}: \d{6}$", out)

    with subtest("changing a sealed PCR invalidates the TOTP"):
      machine.succeed("${pcrExtendCmd}")
      machine.fail("tpm2-totp calculate")

    with subtest("recover with the correct password returns the original secret"):
      out = machine.succeed("tpm2-totp ${totpPassword} recover")
      recovered_secret = extract_secret(out)
      assert recovered_secret == secret, f"recovered secret {recovered_secret!r} != original secret {secret!r}"

    with subtest("recover with a wrong password fails"):
      machine.fail("tpm2-totp ${totpInvalidPassword} recover")

    with subtest("reseal to the current PCR values restores calculate"):
      machine.succeed("tpm2-totp ${totpPassword} ${cfg.sealArgs} reseal")
      machine.succeed("tpm2-totp calculate")

    with subtest("clean removes the secret and calculate fails"):
      machine.succeed("tpm2-totp clean")
      machine.fail("tpm2-totp calculate")
  '';

}
