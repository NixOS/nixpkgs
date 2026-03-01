{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.nfc-nci;

  # To understand these settings in more detail, refer to the upstream configuration templates
  # available at https://github.com/NXPNFCLinux/linux_libnfc-nci/tree/master/conf .
  # Settings in curly braces are NCI commands, the "NFC Controller Interface Specification"
  # as well as the "NFC Digital Protocol Technical Specification" can be found online.
  # These default settings have been specifically engineered for the Lenovo NXP1001 (NPC300) chipset.
  defaultSettings = {
    # This block will be emitted into /etc/libnfc-nci.conf
    nci = {
      # Set up general logging
      APPL_TRACE_LEVEL = "0x01";
      PROTOCOL_TRACE_LEVEL = "0x01";
      # Set up which NFC technologies are enabled (due to e.g. local regulation or patent law)
      HOST_LISTEN_TECH_MASK = "0x07";
      POLLING_TECH_MASK = "0xEF";
      P2P_LISTEN_TECH_MASK = "0xC5";
    };
    # This block will be emitted into /etc/libnfc-nxp-init.conf
    init = {
      # Setup logging of the individual userland library components
      NXPLOG_GLOBAL_LOGLEVEL = "0x01";
      NXPLOG_EXTNS_LOGLEVEL = "0x01";
      NXPLOG_NCIHAL_LOGLEVEL = "0x01";
      NXPLOG_NCIX_LOGLEVEL = "0x01";
      NXPLOG_NCIR_LOGLEVEL = "0x01";
      NXPLOG_FWDNLD_LOGLEVEL = "0x00";
      NXPLOG_TML_LOGLEVEL = "0x01";
      # Where to find the kernel device node
      NXP_NFC_DEV_NODE = ''"/dev/pn544"'';
      # Enable the NXP proprietary features of the chip
      NXP_ACT_PROP_EXTN = "{2F, 02, 00}";
      # Configure the NFC Forum profile:
      # 0xA0 0x44: POLL_PROFILE_SEL_CFG = 0x00 (Use NFC Forum profile default configuration values. Specifically, not EMVCo.)
      NXP_NFC_PROFILE_EXTN = ''
        {20, 02, 05, 01,
          A0, 44, 01, 00
        }
      '';
      # Enable chip standby mode
      NXP_CORE_STANDBY = "{2F, 00, 01, 01}";
      # Enable NCI packet fragmentation on the I2C bus
      NXP_I2C_FRAGMENTATION_ENABLED = "0x01";
    };
    # This block will be emitted into /etc/libnfc-nxp-pn547.conf as well as /etc/libnfc-nxp-pn548.conf
    # Which file is actually used is decided by the library at runtime depending on chip variant, both files are required.
    pn54x = {
      # Enable Mifare Classic reader functionality
      MIFARE_READER_ENABLE = "0x01";
      # Configure clock source - use XTAL (hardware crystal) instead of PLL (synthetic clock)
      NXP_SYS_CLK_SRC_SEL = "0x01";
      NXP_SYS_CLK_FREQ_SEL = "0x00";
      NXP_SYS_CLOCK_TO_CFG = "0x01";
      # Configure the non-propriety NCI settings in EEPROM:
      # 0x28: PN_NFC_DEP_SPEED = 0x00 (Data exchange: Highest Available Bit Rates)
      # 0x21: PI_BIT_RATE = 0x00 (Maximum allowed bit rate: 106 Kbit/s)
      # 0x30: LA_BIT_FRAME_SDD = 0x08 (Bit Frame SDD value to be sent in Byte 1 of SENS_RES)
      # 0x31: LA_PLATFORM_CONFIG = 0x03 (Platform Configuration value to be sent in Byte 2 of SENS_RES)
      # 0x33: LA_NFCID1 = [ 0x04 0x03 0x02 0x01 ] ("Unique" NFCID1 ID in SENS_RES)
      # 0x54: LF_CON_BITR_F = 0x06 (Bit rates to listen for: Both)
      # 0x50: LF_PROTOCOL_TYPE = 0x02 (Protocols supported in Listen Mode for NFC-F: NFC-DEP)
      # 0x5B: LI_BIT_RATE = 0x00 (Maximum supported bit rate: 106 Kbit/s)
      # 0x60: LN_WT = 0x0E (Waiting Time NFC-DEP WT_MAX default for Initiator)
      # 0x80: RF_FIELD_INFO = 0x01 (Chip is allowed to emit RF Field Information Notifications)
      # 0x81: RF_NFCEE_ACTION = 0x01 (Chip should send trigger notification for the default set of NFCEE actions)
      # 0x82: NFCDEP_OP = 0x0E (NFC-DEP protocol behavior: Default flags, but also enable RTOX requests)
      # 0x18: PF_BIT_RATE = 0x01 (NFC-F discovery polling initial bit rate: 106 Kbit/s)
      NXP_CORE_CONF = ''
        {20, 02, 2B, 0D,
          28, 01, 00,
          21, 01, 00,
          30, 01, 08,
          31, 01, 03,
          33, 04, 04, 03, 02, 01,
          54, 01, 06,
          50, 01, 02,
          5B, 01, 00,
          60, 01, 0E,
          80, 01, 01,
          81, 01, 01,
          82, 01, 0E,
          18, 01, 01
        }
      '';
      # Configure the proprietary NXP extension to the NCI standard in EEPROM:
      # 0xA0 0x5E: JEWEL_RID_CFG = 0x01 (Enable sending RID to T1T on RF)
      # 0xA0 0x40: TAG_DETECTOR_CFG = 0x00 (Tag detector: Disable both AGC based detection and trace mode)
      # 0xA0 0x43: TAG_DETECTOR_FALLBACK_CNT_CFG = 0x00 (Tag detector: Disable hybrid mode, only use LPCD to initiate polling)
      # 0xA0 0x0F: DH_EEPROM_AREA_1 = [ 32 bytes of opaque Lenovo data ] (Custom configuration for the Lenovo customized chip firmware)
      # See also https://github.com/nfc-tools/libnfc/issues/455#issuecomment-2221979571
      NXP_CORE_CONF_EXTN = ''
        {20, 02, 30, 04,
          A0, 5E, 01, 01,
          A0, 40, 01, 00,
          A0, 43, 01, 00,
          A0, 0F, 20,
          00, 03, 1D, 01, 03, 00, 02, 00,
          01, 00, 01, 00, 00, 00, 00, 00,
          00, 00, 00, 00, 00, 00, 00, 00,
          00, 00, 00, 00, 00, 00, 00, 00
        }
      '';
      # Firmware-specific protocol configuration parameters (one byte per protocol)
      NXP_NFC_PROPRIETARY_CFG = "{05:FF:FF:06:81:80:70:FF:FF}";
      # Configure power supply of chip, use Lenovo driver configuration, which deviates a bit from the spec:
      # 0xA0 0x0E: PMU_CFG = [ 0x16, 0x09, 0x00 ] (VBAT1 connected to 5V, TVDD monitoring: 3.6V, TxLDO Voltage in reader and card mode: 3.3V)
      NXP_EXT_TVDD_CFG = "0x01";
      NXP_EXT_TVDD_CFG_1 = ''
        {20, 02, 07, 01,
          A0, 0E, 03, 16, 09, 00
        }
      '';
      # Use the default for NFA_EE_MAX_EE_SUPPORTED stack size (concerns HCI)
      NXP_NFC_MAX_EE_SUPPORTED = "0x00";
    };
  };

  generateSettings =
    cfgName:
    let
      toKeyValueLines =
        obj: builtins.concatStringsSep "\n" (map (key: "${key}=${obj.${key}}") (builtins.attrNames obj));
    in
    toKeyValueLines (defaultSettings.${cfgName} // (cfg.settings.${cfgName} or { }));
in
{
  options.hardware.nfc-nci = {
    enable = lib.mkEnableOption "PN5xx kernel module with udev rules, libnfc-nci userland, and optional ifdnfc-nci PC/SC driver";

    settings = lib.mkOption {
      default = defaultSettings;
      description = ''
        Configuration to be written to the libncf-nci configuration files.
        To understand the configuration format, refer to <https://github.com/NXPNFCLinux/linux_libnfc-nci/tree/master/conf>.
      '';
      type = lib.types.attrs;
    };

    enableIFD = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Register ifdnfc-nci as a serial reader with pcscd.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.libnfc-nci
    ]
    ++ lib.optionals cfg.enableIFD [
      pkgs.ifdnfc-nci
    ];

    environment.etc = {
      "libnfc-nci.conf".text = generateSettings "nci";
      "libnfc-nxp-init.conf".text = generateSettings "init";
      "libnfc-nxp-pn547.conf".text = generateSettings "pn54x";
      "libnfc-nxp-pn548.conf".text = generateSettings "pn54x";
    };

    services.udev.packages = [
      config.boot.kernelPackages.nxp-pn5xx
    ];

    boot.blacklistedKernelModules = [
      "nxp_nci_i2c"
      "nxp_nci"
    ];

    boot.extraModulePackages = [
      config.boot.kernelPackages.nxp-pn5xx
    ];

    boot.kernelModules = [
      "nxp-pn5xx"
    ];

    services.pcscd.readerConfigs = lib.mkIf cfg.enableIFD [
      ''
        FRIENDLYNAME "NFC NCI"
        LIBPATH      ${pkgs.ifdnfc-nci}/lib/libifdnfc-nci.so
        CHANNELID    0
      ''
    ];

    # NFC chip looses power when system goes to sleep / hibernate,
    # and needs to be re-initialized upon wakeup
    powerManagement.resumeCommands = lib.mkIf cfg.enableIFD ''
      systemctl restart pcscd.service
    '';
  };

  meta.maintainers = with lib.maintainers; [ stargate01 ];
}
