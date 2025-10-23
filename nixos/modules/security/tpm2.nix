{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.security.tpm2;

  # This snippet is taken from tpm2-tss/dist/tpm-udev.rules, but modified to allow custom user/groups
  # The idea is that the tssUser is allowed to access the TPM and kernel TPM resource manager, while
  # the tssGroup is only allowed to access the kernel resource manager
  # Therefore, if either of the two are null, the respective part isn't generated
  udevRules = tssUser: tssGroup: ''
    ${lib.optionalString (
      tssUser != null
    ) ''KERNEL=="tpm[0-9]*", TAG+="systemd", MODE="0660", OWNER="${tssUser}"''}
    ${
      lib.optionalString (
        tssUser != null || tssGroup != null
      ) ''KERNEL=="tpmrm[0-9]*", TAG+="systemd", MODE="0660"''
      + lib.optionalString (tssUser != null) '', OWNER="${tssUser}"''
      + lib.optionalString (tssGroup != null) '', GROUP="${tssGroup}"''
    }
  '';

  fapiConfig = (
    pkgs.writeText "fapi-config.json" (
      builtins.toJSON (
        {
          profile_name = cfg.fapi.profileName;
          profile_dir = cfg.fapi.profileDir;
          user_dir = cfg.fapi.userDir;
          system_dir = cfg.fapi.systemDir;
          tcti = cfg.fapi.tcti;
          system_pcrs = cfg.fapi.systemPcrs;
          log_dir = cfg.fapi.logDir;
          firmware_log_file = cfg.fapi.firmwareLogFile;
          ima_log_file = cfg.fapi.imaLogFile;
        }
        // lib.optionalAttrs (cfg.fapi.ekCertLess != null) {
          ek_cert_less = if cfg.fapi.ekCertLess then "yes" else "no";
        }
        // lib.optionalAttrs (cfg.fapi.ekFingerprint != null) { ek_fingerprint = cfg.fapi.ekFingerprint; }
      )
    )
  );
in
{
  options.security.tpm2 = {
    enable = lib.mkEnableOption "Trusted Platform Module 2 support";

    tssUser = lib.mkOption {
      description = ''
        Name of the tpm device-owner and service user, set if applyUdevRules is
        set.
      '';
      type = lib.types.nullOr lib.types.str;
      default = if cfg.abrmd.enable then "tss" else "root";
      defaultText = lib.literalExpression ''if config.security.tpm2.abrmd.enable then "tss" else "root"'';
    };

    tssGroup = lib.mkOption {
      description = ''
        Group of the tpm kernel resource manager (tpmrm) device-group, set if
        applyUdevRules is set.
      '';
      type = lib.types.nullOr lib.types.str;
      default = "tss";
    };

    applyUdevRules = lib.mkOption {
      description = ''
        Whether to make the /dev/tpm[0-9] devices accessible by the tssUser, or
        the /dev/tpmrm[0-9] by tssGroup respectively
      '';
      type = lib.types.bool;
      default = true;
    };

    abrmd = {
      enable = lib.mkEnableOption ''
        Trusted Platform 2 userspace resource manager daemon
      '';

      package = lib.mkPackageOption pkgs "tpm2-abrmd" { };
    };

    pkcs11 = {
      enable = lib.mkEnableOption ''
        TPM2 PKCS#11 tool and shared library in system path
        (`/run/current-system/sw/lib/libtpm2_pkcs11.so`)
      '';

      package = lib.mkOption {
        description = "tpm2-pkcs11 package to use";
        type = lib.types.package;
        default = if cfg.abrmd.enable then pkgs.tpm2-pkcs11.abrmd else pkgs.tpm2-pkcs11;
        defaultText = lib.literalExpression "if config.security.tpm2.abrmd.enable then pkgs.tpm2-pkcs11.abrmd else pkgs.tpm2-pkcs11";
      };
    };

    tctiEnvironment = {
      enable = lib.mkOption {
        description = ''
          Set common TCTI environment variables to the specified value.
          The variables are
          - `TPM2TOOLS_TCTI`
          - `TPM2_PKCS11_TCTI`
        '';
        type = lib.types.bool;
        default = false;
      };

      interface = lib.mkOption {
        description = ''
          The name of the TPM command transmission interface (TCTI) library to
          use.
        '';
        type = lib.types.enum [
          "tabrmd"
          "device"
        ];
        default = "device";
      };

      deviceConf = lib.mkOption {
        description = ''
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
        description = ''
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

    fapi = {
      profileName = lib.mkOption {
        description = ''
          Name of the default cryptographic profile chosen from the profile_dir directory.
        '';
        type = lib.types.str;
        default = "P_ECCP256SHA256";
      };

      profileDir = lib.mkOption {
        description = ''
          Directory that contains all cryptographic profiles known to FAPI.
        '';
        type = lib.types.str;
        default = "${pkgs.tpm2-tss}/etc/tpm2-tss/fapi-profiles/";
        defaultText = lib.literalExpression "\${pkgs.tpm2-tss}/etc/fapi-profiles/";
      };

      userDir = lib.mkOption {
        description = ''
          The directory where user objects are stored.
        '';
        type = lib.types.str;
        default = "~/.local/share/tpm2-tss/user/keystore/";
      };

      systemDir = lib.mkOption {
        description = ''
          The directory where system objects, policies, and imported objects are stored.
        '';
        type = lib.types.str;
        default = "/var/lib/tpm2-tss/keystore";
      };

      tcti = lib.mkOption {
        description = ''
          The TCTI which will be used.

          An empty string indicates no TCTI is specified by the FAPI config.

          If not specified in the FAPI config it can be specified by environment
          variable (TPM2TOOLS_TCTI, TPM2_PKCS11_TCTI, etc) or a TCTI will be chosen
          by the FAPI library by searching for tabrmd, device, and mssim TCTIs in
          that order.
        '';
        type = lib.types.str;
        default = "";
        example = "device:/dev/tpmrm0";
      };

      systemPcrs = lib.mkOption {
        description = ''
          The PCR registers which are used by the system.
        '';
        type = lib.types.listOf lib.types.int;
        default = [ ];
      };

      logDir = lib.mkOption {
        description = ''
          The directory for the event log.
        '';
        type = lib.types.str;
        default = "/var/log/tpm2-tss/eventlog/";
      };

      ekCertLess = lib.mkOption {
        description = ''
          A switch to disable Endorsement Key (EK) certificate verification.

          A value of null indicates that the generated fapi config file does not
          contain a ek_cert_less key. The effect of not having that key at all is
          the same as setting its value to false.

          A value of false means that the tss2 cli will not work if there is no
          EK Cert installed, or if the installed EK Cert can't be validated.

          A value of true means that the tss2 cli will work even if there's no EK
          cert installed.
        '';
        type = lib.types.nullOr lib.types.bool;
        default = null;
      };

      ekFingerprint = lib.mkOption {
        description = ''
          The fingerprint of the endorsement key.

          A value of null means that you have chosen not to specify the expected
          fingerprint of the EK. You can still have an endorsement key, it just
          won't get checked to see if it's fingerprint matches a particular value
          before being used.
        '';
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      firmwareLogFile = lib.mkOption {
        description = ''
          The binary bios measurements.
        '';
        type = lib.types.str;
        default = "/sys/kernel/security/tpm0/binary_bios_measurements";
      };

      imaLogFile = lib.mkOption {
        description = ''
          The binary IMA measurements (Integrity Measurement Architecture).
        '';
        type = lib.types.str;
        default = "/sys/kernel/security/ima/binary_runtime_measurements";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # PKCS11 tools and library
        environment.systemPackages = lib.mkIf cfg.pkcs11.enable [
          (lib.getBin cfg.pkcs11.package)
          (lib.getLib cfg.pkcs11.package)
        ];

        services.udev.extraRules = lib.mkIf cfg.applyUdevRules (udevRules cfg.tssUser cfg.tssGroup);

        # Create the tss user and group only if the default value is used
        users.users.${cfg.tssUser} = lib.mkIf (cfg.tssUser == "tss") {
          isSystemUser = true;
          group = "tss";
        };
        users.groups.${cfg.tssGroup} = lib.mkIf (cfg.tssGroup == "tss") { };

        environment.variables = lib.mkIf cfg.tctiEnvironment.enable (
          lib.attrsets.genAttrs
            [
              "TPM2TOOLS_TCTI"
              "TPM2_PKCS11_TCTI"
            ]
            (
              _:
              ''${cfg.tctiEnvironment.interface}:${
                if cfg.tctiEnvironment.interface == "tabrmd" then
                  cfg.tctiEnvironment.tabrmdConf
                else
                  cfg.tctiEnvironment.deviceConf
              }''
            )
        );
      }

      {
        # This script has the hash of the udev rules in it,
        # and also writes that hash to
        # /var/lib/tpm2-udev-trigger/hash.txt at the end.
        # On each run, it checks to see if the hash embedded in the script
        # matches the hash on disk. If they are different, that
        # indicates that the udev rules created by this module
        # have changed. In that case, a udev change is triggered
        # for tpm and tpmrm devices so that the new rules are
        # applied at the end of a nixos-rebuild switch or activate
        systemd.services."tpm2-udev-trigger" =
          let
            udevHash =
              if cfg.applyUdevRules then (builtins.hashString "md5" (udevRules cfg.tssUser cfg.tssGroup)) else "";
          in
          {
            description = "Trigger udev change for TPM devices";
            wants = [ "systemd-udevd.service" ];
            after = [
              "tpm2.target"
              "systemd-udevd.service"
            ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = pkgs.writeShellScript "tpm2-udev-trigger.sh" ''
                stateDir=/var/lib/tpm2-udev-trigger
                mkdir -p $stateDir
                newHash=${udevHash}
                hashFile=$stateDir/hash.txt

                # if file exists, read old hash
                if [ -f $hashFile ]; then
                  oldHash="$(< $hashFile)"
                else
                  oldHash=""
                fi

                if [ "$oldHash" != "$newHash" ]; then
                  echo "TPM udev rules changed, triggering udev"
                  ${config.systemd.package}/bin/udevadm trigger --subsystem-match=tpm --action=change
                  ${config.systemd.package}/bin/udevadm trigger --subsystem-match=tpmrm --action=change
                  echo "$newHash" > $hashFile
                else
                  echo "TPM udev rules unchanged, not triggering udev"
                fi
              '';
            };
          };
      }

      (lib.mkIf cfg.abrmd.enable {
        systemd.services."tpm2-abrmd" = {
          wants = [
            "tpm2-udev-trigger.service"
            "dev-tpm0.device"
          ];
          after = [
            "tpm2-udev-trigger.service"
            "dev-tpm0.device"
          ];
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

      {
        environment.etc."tpm2-tss/fapi-config.json".source = fapiConfig;
        systemd.tmpfiles.rules = [
          "d ${cfg.fapi.logDir} 2750 ${cfg.tssUser} ${cfg.tssGroup} -"
          "d ${cfg.fapi.systemDir} 2750 root ${cfg.tssGroup} -"
        ];
      }
    ]
  );

  meta.doc = ./tpm2.md;
  meta.maintainers = with lib.maintainers; [
    lschuermann
    scottstephens
  ];
}
