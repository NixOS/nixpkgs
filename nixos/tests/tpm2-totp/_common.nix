# common test properties shared across the tpm2-totp tests
{
  config,
  lib,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  inherit (lib) types;
  inherit (lib.options) mkOption;
  inherit (lib.strings) escapeShellArgs;

  cfg = config.test-tpm2-totp;
in
{

  _class = "nixosTest";

  # for shared test properties
  # (makes it easier to reuse tests externally with different PCRs)
  options.test-tpm2-totp = {

    banks = mkOption {
      type = with types; listOf str;
      default = [
        "SHA1"
        "SHA256"
      ];
      description = "PCR banks to seal secret of tpm2-totp against";
    };

    bankToHexLength = mkOption {
      type = with types; attrsOf int;
      default = {
        SHA1 = 40;
        SHA256 = 64;
      };
      description = "Length of hex-encoded PCR value for each supported bank";
    };

    sealArgs = mkOption {
      type = types.str;
      internal = true;
      readOnly = true;
      default = escapeShellArgs [
        "--banks"
        (concatStringsSep "," cfg.banks)
        "--pcrs"
        (concatStringsSep "," cfg.pcrs)
      ];
      description = "Arguments for tpm2-totp when generating a secret";
    };

    pcrs = mkOption {
      type = with types; listOf str;
      default = [
        "0"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
      ];
      description = "PCRs to seal secret of tpm2-totp against";
    };

  };

  config = {

    # tests are similar enough to share maintainers
    meta.maintainers = with lib.maintainers; [
      Zocker1999NET
    ];

    nodes.machine.virtualisation = {

      # obviously required
      tpm.enable = true;

      # interestingly not actually required for tests to pass
      # but is a more realistic setup than legacy boot
      useEFIBoot = true;

    };

  };
}
