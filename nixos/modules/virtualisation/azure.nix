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
    services.openssh.settings.PermitRootLogin = "prohibit-password";
    services.openssh.settings.ClientAliveInterval = 180;

    # Force getting the hostname from Azure
    networking.hostName = mkDefault "";

    # Always include cryptsetup so that NixOps can use it.
    # sg_scan is needed to finalize disk removal on older kernels
    environment.systemPackages = [ pkgs.cryptsetup pkgs.sg3_utils ];

    networking.usePredictableInterfaceNames = false;

    services.udev.extraRules = ''
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:0", ATTR{removable}=="0", SYMLINK+="disk/by-lun/0",
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:1", ATTR{removable}=="0", SYMLINK+="disk/by-lun/1",
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:2", ATTR{removable}=="0", SYMLINK+="disk/by-lun/2"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:3", ATTR{removable}=="0", SYMLINK+="disk/by-lun/3"

      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:4", ATTR{removable}=="0", SYMLINK+="disk/by-lun/4"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:5", ATTR{removable}=="0", SYMLINK+="disk/by-lun/5"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:6", ATTR{removable}=="0", SYMLINK+="disk/by-lun/6"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:7", ATTR{removable}=="0", SYMLINK+="disk/by-lun/7"

      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:8", ATTR{removable}=="0", SYMLINK+="disk/by-lun/8"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:9", ATTR{removable}=="0", SYMLINK+="disk/by-lun/9"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:10", ATTR{removable}=="0", SYMLINK+="disk/by-lun/10"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:11", ATTR{removable}=="0", SYMLINK+="disk/by-lun/11"

      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:12", ATTR{removable}=="0", SYMLINK+="disk/by-lun/12"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:13", ATTR{removable}=="0", SYMLINK+="disk/by-lun/13"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:14", ATTR{removable}=="0", SYMLINK+="disk/by-lun/14"
      ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:15", ATTR{removable}=="0", SYMLINK+="disk/by-lun/15"

    '';
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
