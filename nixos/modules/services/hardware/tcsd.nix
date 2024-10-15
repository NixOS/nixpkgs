# tcsd daemon.
{ config, options, pkgs, lib, ... }:
let

  cfg = config.services.tcsd;
  opt = options.services.tcsd;

  tcsdConf = pkgs.writeText "tcsd.conf" ''
    port = 30003
    num_threads = 10
    system_ps_file = ${cfg.stateDir}/system.data
    # This is the log of each individual measurement done by the system.
    # By re-calculating the PCR registers based on this information, even
    # finer details about the measured environment can be inferred than
    # what is available directly from the PCR registers.
    firmware_log_file = /sys/kernel/security/tpm0/binary_bios_measurements
    kernel_log_file = /sys/kernel/security/ima/binary_runtime_measurements
    firmware_pcrs = ${cfg.firmwarePCRs}
    kernel_pcrs = ${cfg.kernelPCRs}
    platform_cred = ${cfg.platformCred}
    conformance_cred = ${cfg.conformanceCred}
    endorsement_cred = ${cfg.endorsementCred}
    #remote_ops = create_key,random
    #host_platform_class = server_12
    #all_platform_classes = pc_11,pc_12,mobile_12
  '';

in
{

  ###### interface

  options = {

    services.tcsd = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable tcsd, a Trusted Computing management service
          that provides TCG Software Stack (TSS).  The tcsd daemon is
          the only portal to the Trusted Platform Module (TPM), a hardware
          chip on the motherboard.
        '';
      };

      user = lib.mkOption {
        default = "tss";
        type = lib.types.str;
        description = "User account under which tcsd runs.";
      };

      group = lib.mkOption {
        default = "tss";
        type = lib.types.str;
        description = "Group account under which tcsd runs.";
      };

      stateDir = lib.mkOption {
        default = "/var/lib/tpm";
        type = lib.types.path;
        description = ''
          The location of the system persistent storage file.
          The system persistent storage file holds keys and data across
          restarts of the TCSD and system reboots.
        '';
      };

      firmwarePCRs = lib.mkOption {
        default = "0,1,2,3,4,5,6,7";
        type = lib.types.str;
        description = "PCR indices used in the TPM for firmware measurements.";
      };

      kernelPCRs = lib.mkOption {
        default = "8,9,10,11,12";
        type = lib.types.str;
        description = "PCR indices used in the TPM for kernel measurements.";
      };

      platformCred = lib.mkOption {
        default = "${cfg.stateDir}/platform.cert";
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/platform.cert"'';
        type = lib.types.path;
        description = ''
          Path to the platform credential for your TPM. Your TPM
          manufacturer may have provided you with a set of credentials
          (certificates) that should be used when creating identities
          using your TPM. When a user of your TPM makes an identity,
          this credential will be encrypted as part of that process.
          See the 1.1b TPM Main specification section 9.3 for information
          on this process. '';
      };

      conformanceCred = lib.mkOption {
        default = "${cfg.stateDir}/conformance.cert";
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/conformance.cert"'';
        type = lib.types.path;
        description = ''
          Path to the conformance credential for your TPM.
          See also the platformCred option'';
      };

      endorsementCred = lib.mkOption {
        default = "${cfg.stateDir}/endorsement.cert";
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/endorsement.cert"'';
        type = lib.types.path;
        description = ''
          Path to the endorsement credential for your TPM.
          See also the platformCred option'';
      };
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.trousers ];

    services.udev.extraRules = ''
      # Give tcsd ownership of all TPM devices
      KERNEL=="tpm[0-9]*", MODE="0660", OWNER="${cfg.user}", GROUP="${cfg.group}"
      # Tag TPM devices to create a .device unit for tcsd to depend on
      ACTION=="add", KERNEL=="tpm[0-9]*", TAG+="systemd"
    '';

    systemd.tmpfiles.rules = [
      # Initialise the state directory
      "d ${cfg.stateDir} 0770 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.tcsd = {
      description = "Manager for Trusted Computing resources";
      documentation = [ "man:tcsd(8)" ];

      requires = [ "dev-tpm0.device" ];
      after = [ "dev-tpm0.device" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.trousers}/sbin/tcsd -f -c ${tcsdConf}";
      };
    };

    users.users = lib.optionalAttrs (cfg.user == "tss") {
      tss = {
        group = "tss";
        isSystemUser = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "tss") { tss = {}; };
  };
}
