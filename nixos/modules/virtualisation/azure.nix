{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.virtualisation.azure;
in {
  imports = [ ../profiles/headless.nix ];

  options.virtualisation.azure = with types; {
    getSshKeys = mkOption {
      type = bool;
      description = "Allow access for ssh authorized keys in azure vm metadata.";
      default = true;
    };

    executeUserData = mkOption {
      type = bool;
      description = ''
        Execute userdata from azure metadata at startup.
        For example you can add "nix --experimental-features 'nix-command flakes' run nixpkgs#hello"
        to userdata in azure metadata, to run hello world at start up.
      '';
      default = false;
    };
  };

  config = mkMerge [
  {
    boot.kernelParams = [ "console=ttyS0" "earlyprintk=ttyS0" "rootdelay=300" "panic=1" "boot.panic_on_fail" ];
    boot.initrd.kernelModules = [ "hv_vmbus" "hv_netvsc" "hv_utils" "hv_storvsc" ];

    # Generate a GRUB menu.
    boot.loader.grub.device = "/dev/sda";
    boot.loader.timeout = 0;

    boot.growPartition = true;

    # Don't put old configurations in the GRUB menu.  The user has no
    # way to select them anyway.
    boot.loader.grub.configurationLimit = 0;

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    # Allow root logins only using the SSH key that the user specified
    # at instance creation time, ping client connections to avoid timeouts
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = mkDefault false;
    services.openssh.settings.ClientAliveInterval = 180;

    # Azure Bastion do not support nixos default Macs so need to add one
    # that Azure support.
    services.openssh.settings.Macs = lib.mkOptionDefault [ "hmac-sha2-512" ];

    # Force getting the hostname from Azure
    networking.hostName = mkDefault "";

    # Always include cryptsetup so that NixOps can use it.
    # sg_scan is needed to finalize disk removal on older kernels
    environment.systemPackages = [ pkgs.cryptsetup pkgs.sg3_utils ];

    networking.usePredictableInterfaceNames = false;

    #https://docs.microsoft.com/en-us/troubleshoot/azure/virtual-machines/troubleshoot-device-names-problems#get-the-latest-azure-storage-rules
    #https://raw.githubusercontent.com/Azure/WALinuxAgent/master/config/66-azure-storage.rules
    services.udev.packages = [
      (pkgs.writeTextFile {
      name = "azure-storage-udev-rules";
      destination = "/lib/udev/rules.d/66-azure-storage.rules";
      text = ''
# Azure specific rules.
ACTION!="add|change", GOTO="walinuxagent_end"
SUBSYSTEM!="block", GOTO="walinuxagent_end"
ATTRS{ID_VENDOR}!="Msft", GOTO="walinuxagent_end"
ATTRS{ID_MODEL}!="Virtual_Disk", GOTO="walinuxagent_end"

# Match the known ID parts for root and resource disks.
ATTRS{device_id}=="?00000000-0000-*", ENV{fabric_name}="root", GOTO="wa_azure_names"
ATTRS{device_id}=="?00000000-0001-*", ENV{fabric_name}="resource", GOTO="wa_azure_names"

# Gen2 disk.
ATTRS{device_id}=="{f8b3781a-1e82-4818-a1c3-63d806ec15bb}", ENV{fabric_scsi_controller}="scsi0", GOTO="azure_datadisk"
# Create symlinks for data disks attached.
ATTRS{device_id}=="{f8b3781b-1e82-4818-a1c3-63d806ec15bb}", ENV{fabric_scsi_controller}="scsi1", GOTO="azure_datadisk"
ATTRS{device_id}=="{f8b3781c-1e82-4818-a1c3-63d806ec15bb}", ENV{fabric_scsi_controller}="scsi2", GOTO="azure_datadisk"
ATTRS{device_id}=="{f8b3781d-1e82-4818-a1c3-63d806ec15bb}", ENV{fabric_scsi_controller}="scsi3", GOTO="azure_datadisk"
GOTO="walinuxagent_end"

# Parse out the fabric n ame based off of scsi indicators.
LABEL="azure_datadisk"
ENV{DEVTYPE}=="partition", PROGRAM="${pkgs.bash}/bin/sh -c 'readlink /sys/class/block/%k/../device|cut -d: -f4'", ENV{fabric_name}="$env{fabric_scsi_controller}/lun$result"
ENV{DEVTYPE}=="disk", PROGRAM="${pkgs.bash}/bin/sh -c 'readlink /sys/class/block/%k/device|cut -d: -f4'", ENV{fabric_name}="$env{fabric_scsi_controller}/lun$result"

ENV{fabric_name}=="scsi0/lun0", ENV{fabric_name}="root"
ENV{fabric_name}=="scsi0/lun1", ENV{fabric_name}="resource"
# Don't create a symlink for the cd-rom.
ENV{fabric_name}=="scsi0/lun2", GOTO="walinuxagent_end"

# Create the symlinks.
LABEL="wa_azure_names"
ENV{DEVTYPE}=="disk", SYMLINK+="disk/azure/$env{fabric_name}"
ENV{DEVTYPE}=="partition", SYMLINK+="disk/azure/$env{fabric_name}-part%n"

LABEL="walinuxagent_end"
        '';
      })

    # https://raw.githubusercontent.com/Azure/WALinuxAgent/master/config/99-azure-product-uuid.rules
    (pkgs.writeTextFile {
      name = "azure-product-uuid-udev-rules";
      destination = "/lib/udev/rules.d/99-azure-product-uuid.rules";
      text = ''
SUBSYSTEM!="dmi", GOTO="product_uuid-exit"
ATTR{sys_vendor}!="Microsoft Corporation", GOTO="product_uuid-exit"
ATTR{product_name}!="Virtual Machine", GOTO="product_uuid-exit"
TEST!="/sys/devices/virtual/dmi/id/product_uuid", GOTO="product_uuid-exit"

RUN+="${pkgs.coreutils}/bin/chmod 0444 /sys/devices/virtual/dmi/id/product_uuid"

LABEL="product_uuid-exit"
        '';
      })
    ];
  }

  (mkIf cfg.getSshKeys (
  let
    get-authorized-keys-from-azure = pkgs.writeShellApplication {
      name = "get-authorized-keys-from-azure";
      runtimeInputs = with pkgs; [ curl jq bash ];
      text = ''
        PUBLIC_KEYS=$(curl --retry 6 --retry-all-errors -H Metadata:true --noproxy "*"\
          "http://169.254.169.254/metadata/instance/compute/publicKeys?api-version=2021-10-01&format=json"
        )

        echo "$PUBLIC_KEYS" | jq --arg USERNAME "$1" -r 'map(select(.path == "/home/" + $USERNAME + "/.ssh/authorized_keys")) | .[] | .keyData'
      '';
    };
  in {
    environment.etc."ssh/get-authorized-keys-from-azure" = {
       mode = "0555";
       source = "${get-authorized-keys-from-azure}/bin/get-authorized-keys-from-azure";
     };

    services.openssh.authorizedKeysCommand = "/etc/ssh/get-authorized-keys-from-azure";
  }))

  (mkIf cfg.executeUserData {
    systemd.services.azure-execute-userdata = let
      execute-userdata = pkgs.writeShellApplication {
          name = "execute-userdata";
          runtimeInputs = with pkgs; [ curl coreutils config.nix.package config.system.build.nixos-rebuild ];
          text = ''
            userData=$(curl --retry 6 --retry-all-errors -H Metadata:true --noproxy "*"\
              "http://169.254.169.254/metadata/instance/compute/userData?api-version=2021-10-01&format=text"\
            | base64 --decode)

            if [ -n "$userData" ]
            then
	            echo "Execute azure userdata"
              eval "$userData"
            else
              echo "Azure userdata is empty"
            fi
          '';
        };
    in {
      description = "Execute userdata from azure metadata";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      path = [ execute-userdata ];

      environment = {
        # For nix-shell, nix-buld, ..,
        NIX_PATH = "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        execute-userdata
      '';
    };
  })
  ];
}
