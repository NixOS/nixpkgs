# Module for VirtualBox guests.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.virtualbox.guest;
  kernel = config.boot.kernelPackages;

  mkVirtualBoxUserService = serviceArgs: {
    description = "VirtualBox Guest User Services ${serviceArgs}";

    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    # The graphical session may not be ready when starting the service
    # Hence, check if the DISPLAY env var is set, otherwise fail, wait and retry again
    startLimitBurst = 20;

    unitConfig.ConditionVirtualization = "oracle";

    # Check if the display environment is ready, otherwise fail
    preStart = "${pkgs.bash}/bin/bash -c \"if [ -z $DISPLAY ]; then exit 1; fi\"";
    serviceConfig = {
      ExecStart = "@${kernel.virtualboxGuestAdditions}/bin/VBoxClient --foreground ${serviceArgs}";
      # Wait after a failure, hoping that the display environment is ready after waiting
      RestartSec = 2;
      Restart = "always";
    };
  };
in
{
  ###### interface

  options.virtualisation.virtualbox.guest = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc "Whether to enable the VirtualBox service and other guest additions.";
    };

    clipboard = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc "Whether to enable clipboard support.";
    };

    seamless = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc "Whether to enable seamless mode. When activated windows from the guest appear next to the windows of the host.";
    };

    draganddrop = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc "Whether to enable drag and drop support.";
    };
  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [{
        assertion = pkgs.stdenv.hostPlatform.isx86;
        message = "Virtualbox not currently supported on ${pkgs.stdenv.hostPlatform.system}";
      }];

      environment.systemPackages = [ kernel.virtualboxGuestAdditions ];

      boot.extraModulePackages = [ kernel.virtualboxGuestAdditions ];

      boot.supportedFilesystems = [ "vboxsf" ];
      boot.initrd.supportedFilesystems = [ "vboxsf" ];

      users.groups.vboxsf.gid = config.ids.gids.vboxsf;

      systemd.services.virtualbox = {
        description = "VirtualBox Guest Services";

        wantedBy = [ "multi-user.target" ];
        requires = [ "dev-vboxguest.device" ];
        after = [ "dev-vboxguest.device" ];

        unitConfig.ConditionVirtualization = "oracle";

        serviceConfig.ExecStart = "@${kernel.virtualboxGuestAdditions}/bin/VBoxService VBoxService --foreground";
      };

      services.udev.extraRules =
        ''
          # /dev/vboxuser is necessary for VBoxClient to work.  Maybe we
          # should restrict this to logged-in users.
          KERNEL=="vboxuser",  OWNER="root", GROUP="root", MODE="0666"

          # Allow systemd dependencies on vboxguest.
          SUBSYSTEM=="misc", KERNEL=="vboxguest", TAG+="systemd"
        '';

      systemd.user.services.virtualboxClientVmsvga = mkVirtualBoxUserService "--vmsvga-session";
    }
    (
      mkIf cfg.clipboard {
        systemd.user.services.virtualboxClientClipboard = mkVirtualBoxUserService "--clipboard";
      }
    )
    (
      mkIf cfg.seamless {
        systemd.user.services.virtualboxClientSeamless = mkVirtualBoxUserService "--seamless";
      }
    )
  ]);
}
