{ config, lib, ... }:
with lib;
let
  cfg = config.hardware.cpu.intel.sgx;
  defaultPrvGroup = "sgx_prv";
in
{
  options.hardware.cpu.intel.sgx.enableDcapCompat = mkOption {
    description = ''
      Whether to enable backward compatibility for SGX software build for the
      out-of-tree Intel SGX DCAP driver.

      Creates symbolic links for the SGX devices `/dev/sgx_enclave`
      and `/dev/sgx_provision` to make them available as
      `/dev/sgx/enclave`  and `/dev/sgx/provision`,
      respectively.
    '';
    type = types.bool;
    default = true;
  };

  options.hardware.cpu.intel.sgx.provision = {
    enable = mkEnableOption "access to the Intel SGX provisioning device";
    user = mkOption {
      description = "Owner to assign to the SGX provisioning device.";
      type = types.str;
      default = "root";
    };
    group = mkOption {
      description = "Group to assign to the SGX provisioning device.";
      type = types.str;
      default = defaultPrvGroup;
    };
    mode = mkOption {
      description = "Mode to set for the SGX provisioning device.";
      type = types.str;
      default = "0660";
    };
  };

  config = mkMerge [
    (mkIf cfg.provision.enable {
      assertions = [
        {
          assertion = hasAttr cfg.provision.user config.users.users;
          message = "Given user does not exist";
        }
        {
          assertion =
            (cfg.provision.group == defaultPrvGroup) || (hasAttr cfg.provision.group config.users.groups);
          message = "Given group does not exist";
        }
      ];

      users.groups = optionalAttrs (cfg.provision.group == defaultPrvGroup) {
        "${cfg.provision.group}" = { };
      };

      services.udev.extraRules = with cfg.provision; ''
        SUBSYSTEM=="misc", KERNEL=="sgx_provision", OWNER="${user}", GROUP="${group}", MODE="${mode}"
      '';
    })
    (mkIf cfg.enableDcapCompat {
      services.udev.extraRules = ''
        SUBSYSTEM=="misc", KERNEL=="sgx_enclave",   SYMLINK+="sgx/enclave"
        SUBSYSTEM=="misc", KERNEL=="sgx_provision", SYMLINK+="sgx/provision"
      '';
    })
  ];
}
