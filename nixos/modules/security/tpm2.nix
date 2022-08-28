{ lib, pkgs, config, ... }:
let
  cfg = config.security.tpm2;

  # This snippet is taken from tpm2-tss/dist/tpm-udev.rules, but modified to allow custom user/groups
  # The idea is that the tssUser is allowed to acess the TPM and kernel TPM resource manager, while
  # the tssGroup is only allowed to access the kernel resource manager
  # Therefore, if either of the two are null, the respective part isn't generated
  udevRules = tssUser: tssGroup: ''
    ${lib.optionalString (tssUser != null) ''KERNEL=="tpm[0-9]*", MODE="0660", OWNER="${tssUser}"''}
    ${lib.optionalString (tssUser != null || tssGroup != null)
      ''KERNEL=="tpmrm[0-9]*", MODE="0660"''
      + lib.optionalString (tssUser != null) '', OWNER="${tssUser}"''
      + lib.optionalString (tssGroup != null) '', GROUP="${tssGroup}"''
     }
  '';

in {
  options.security.tpm2 = {
    enable = lib.mkEnableOption (lib.mdDoc "Trusted Platform Module 2 support");

    tssUser = lib.mkOption {
      description = lib.mdDoc ''
        Name of the tpm device-owner and service user, set if applyUdevRules is
        set.
      '';
      type = lib.types.nullOr lib.types.str;
      default = if cfg.abrmd.enable then "tss" else "root";
      defaultText = lib.literalExpression ''if config.security.tpm2.abrmd.enable then "tss" else "root"'';
    };

    tssGroup = lib.mkOption {
      description = lib.mdDoc ''
        Group of the tpm kernel resource manager (tpmrm) device-group, set if
        applyUdevRules is set.
      '';
      type = lib.types.nullOr lib.types.str;
      default = "tss";
    };

    applyUdevRules = lib.mkOption {
      description = lib.mdDoc ''
        Whether to make the /dev/tpm[0-9] devices accessible by the tssUser, or
        the /dev/tpmrm[0-9] by tssGroup respectively
      '';
      type = lib.types.bool;
      default = true;
    };

    abrmd = {
      enable = lib.mkEnableOption (lib.mdDoc ''
        Trusted Platform 2 userspace resource manager daemon
      '');

      package = lib.mkOption {
        description = lib.mdDoc "tpm2-abrmd package to use";
        type = lib.types.package;
        default = pkgs.tpm2-abrmd;
        defaultText = lib.literalExpression "pkgs.tpm2-abrmd";
      };
    };

    pkcs11 = {
      enable = lib.mkEnableOption (lib.mdDoc ''
        TPM2 PKCS#11 tool and shared library in system path
        (`/run/current-system/sw/lib/libtpm2_pkcs11.so`)
      '');

      package = lib.mkOption {
        description = lib.mdDoc "tpm2-pkcs11 package to use";
        type = lib.types.package;
        default = pkgs.tpm2-pkcs11;
        defaultText = lib.literalExpression "pkgs.tpm2-pkcs11";
      };
    };

    tctiEnvironment = {
      enable = lib.mkOption {
        description = lib.mdDoc ''
          Set common TCTI environment variables to the specified value.
          The variables are
          - `TPM2TOOLS_TCTI`
          - `TPM2_PKCS11_TCTI`
        '';
        type = lib.types.bool;
        default = false;
      };

      interface = lib.mkOption {
        description = lib.mdDoc ''
          The name of the TPM command transmission interface (TCTI) library to
          use.
        '';
        type = lib.types.enum [ "tabrmd" "device" ];
        default = "device";
      };

      deviceConf = lib.mkOption {
        description = lib.mdDoc ''
          Configuration part of the device TCTI, e.g. the path to the TPM device.
          Applies if interface is set to "device".
          The format is specified in the
          [
          tpm2-tools repository](https://github.com/tpm2-software/tpm2-tools/blob/master/man/common/tcti.md#tcti-options).
        '';
        type = lib.types.str;
        default = "/dev/tpmrm0";
      };

      tabrmdConf = lib.mkOption {
        description = lib.mdDoc ''
          Configuration part of the tabrmd TCTI, like the D-Bus bus name.
          Applies if interface is set to "tabrmd".
          The format is specified in the
          [
          tpm2-tools repository](https://github.com/tpm2-software/tpm2-tools/blob/master/man/common/tcti.md#tcti-options).
        '';
        type = lib.types.str;
        default = "bus_name=com.intel.tss2.Tabrmd";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      # PKCS11 tools and library
      environment.systemPackages = lib.mkIf cfg.pkcs11.enable [
        (lib.getBin cfg.pkcs11.package)
        (lib.getLib cfg.pkcs11.package)
      ];

      services.udev.extraRules = lib.mkIf cfg.applyUdevRules
        (udevRules cfg.tssUser cfg.tssGroup);

      # Create the tss user and group only if the default value is used
      users.users.${cfg.tssUser} = lib.mkIf (cfg.tssUser == "tss") {
        isSystemUser = true;
        group = "tss";
      };
      users.groups.${cfg.tssGroup} = lib.mkIf (cfg.tssGroup == "tss") {};

      environment.variables = lib.mkIf cfg.tctiEnvironment.enable (
        lib.attrsets.genAttrs [
          "TPM2TOOLS_TCTI"
          "TPM2_PKCS11_TCTI"
        ] (_: ''${cfg.tctiEnvironment.interface}:${
          if cfg.tctiEnvironment.interface == "tabrmd" then
            cfg.tctiEnvironment.tabrmdConf
          else
            cfg.tctiEnvironment.deviceConf
        }'')
      );
    }

    (lib.mkIf cfg.abrmd.enable {
      systemd.services."tpm2-abrmd" = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "dbus";
          Restart = "always";
          RestartSec = 30;
          BusName = "com.intel.tss2.Tabrmd";
          ExecStart = "${cfg.abrmd.package}/bin/tpm2-abrmd";
          User = "tss";
          Group = "tss";
        };
      };

      services.dbus.packages = lib.singleton cfg.abrmd.package;
    })
  ]);

  meta.maintainers = with lib.maintainers; [ lschuermann ];
}
