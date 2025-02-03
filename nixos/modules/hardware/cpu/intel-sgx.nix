{ config, lib, ... }:
let
  cfg = config.hardware.cpu.intel.sgx;
  defaultPrvGroup = "sgx_prv";
in
{
  options.hardware.cpu.intel.sgx.enableDcapCompat = lib.mkOption {
    description = ''
      Whether to enable backward compatibility for SGX software build for the
      out-of-tree Intel SGX DCAP driver.

      Creates symbolic links for the SGX devices `/dev/sgx_enclave`
      and `/dev/sgx_provision` to make them available as
      `/dev/sgx/enclave`  and `/dev/sgx/provision`,
      respectively.
    '';
    type = lib.types.bool;
    default = true;
  };

  options.hardware.cpu.intel.sgx.provision = {
    enable = lib.mkEnableOption "access to the Intel SGX provisioning device";
    user = lib.mkOption {
      description = "Owner to assign to the SGX provisioning device.";
      type = lib.types.str;
      default = "root";
    };
    group = lib.mkOption {
      description = "Group to assign to the SGX provisioning device.";
      type = lib.types.str;
      default = defaultPrvGroup;
    };
    mode = lib.mkOption {
      description = "Mode to set for the SGX provisioning device.";
      type = lib.types.str;
      default = "0660";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.provision.enable {
      assertions = [
        {
          assertion = lib.hasAttr cfg.provision.user config.users.users;
          message = "Given user does not exist";
        }
        {
          assertion = (cfg.provision.group == defaultPrvGroup) || (lib.hasAttr cfg.provision.group config.users.groups);
          message = "Given group does not exist";
        }
      ];

      users.groups = lib.optionalAttrs (cfg.provision.group == defaultPrvGroup) {
        "${cfg.provision.group}" = { };
      };

      services.udev.extraRules = with cfg.provision; ''
        SUBSYSTEM=="misc", KERNEL=="sgx_provision", OWNER="${user}", GROUP="${group}", MODE="${mode}"
      '';
    })
    (lib.mkIf cfg.enableDcapCompat {
      services.udev.extraRules = ''
        SUBSYSTEM=="misc", KERNEL=="sgx_enclave",   SYMLINK+="sgx/enclave"
        SUBSYSTEM=="misc", KERNEL=="sgx_provision", SYMLINK+="sgx/provision"
      '';
    })
  ];
}
