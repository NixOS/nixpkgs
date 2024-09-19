{
  lib,
  config,
  pkgs,
  ...
}:
{
  meta.maintainers = [ lib.maintainers.elvishjerricco ];

  imports = [
    (lib.mkRenamedOptionModule
      [
        "boot"
        "initrd"
        "systemd"
        "enableTpm2"
      ]
      [
        "boot"
        "initrd"
        "systemd"
        "tpm2"
        "enable"
      ]
    )
  ];

  options = {
    systemd.tpm2.enable = lib.mkEnableOption "systemd TPM2 support" // {
      default = config.systemd.package.withTpm2Tss;
      defaultText = "systemd.package.withTpm2Tss";
    };

    boot.initrd.systemd.tpm2.enable = lib.mkEnableOption "systemd initrd TPM2 support" // {
      default = config.boot.initrd.systemd.package.withTpm2Tss;
      defaultText = "boot.initrd.systemd.package.withTpm2Tss";
    };
  };

  # TODO: pcrphase, pcrextend, pcrfs, pcrmachine
  config = lib.mkMerge [
    # Stage 2
    (
      let
        cfg = config.systemd;
      in
      lib.mkIf cfg.tpm2.enable {
        systemd.additionalUpstreamSystemUnits = [
          "tpm2.target"
        ];
      }
    )

    # Stage 1
    (
      let
        cfg = config.boot.initrd.systemd;
      in
      lib.mkIf cfg.tpm2.enable {
        boot.initrd.systemd.additionalUpstreamUnits = [
          "tpm2.target"
        ];

        boot.initrd.availableKernelModules =
          [ "tpm-tis" ]
          ++ lib.optional (
            !(pkgs.stdenv.hostPlatform.isRiscV64 || pkgs.stdenv.hostPlatform.isArmv7)
          ) "tpm-crb";
        boot.initrd.systemd.storePaths = [
          pkgs.tpm2-tss
        ];
      }
    )
  ];
}
