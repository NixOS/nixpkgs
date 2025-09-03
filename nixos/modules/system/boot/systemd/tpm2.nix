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
      default = config.systemd.package.withTpm2Units;
      defaultText = "systemd.package.withTpm2Units";
    };

    boot.initrd.systemd.tpm2.enable = lib.mkEnableOption "systemd initrd TPM2 support" // {
      default = config.boot.initrd.systemd.package.withTpm2Units;
      defaultText = "boot.initrd.systemd.package.withTpm2Units";
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
          "systemd-tpm2-setup-early.service"
          "systemd-tpm2-setup.service"
        ];
      }
    )

    # Stage 1
    (
      let
        cfg = config.boot.initrd.systemd;
      in
      lib.mkIf (cfg.enable && cfg.tpm2.enable) {
        boot.initrd.systemd.additionalUpstreamUnits = [
          "tpm2.target"
          "systemd-tpm2-setup-early.service"
        ];

        boot.initrd.availableKernelModules = [
          "tpm-tis"
        ]
        ++ lib.optional (
          !(pkgs.stdenv.hostPlatform.isRiscV64 || pkgs.stdenv.hostPlatform.isArmv7)
        ) "tpm-crb";
        boot.initrd.systemd.storePaths = [
          pkgs.tpm2-tss
          "${cfg.package}/lib/systemd/systemd-tpm2-setup"
          "${cfg.package}/lib/systemd/system-generators/systemd-tpm2-generator"
        ];
      }
    )
  ];
}
