# Module for VirtualBox guests.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.virtualbox.guest;
  kernel = config.boot.kernelPackages;

  mkVirtualBoxUserService = serviceArgs: verbose: {
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
      ExecStart =
        "@${kernel.virtualboxGuestAdditions}/bin/VBoxClient"
        + (lib.strings.optionalString verbose " --verbose")
        + " --foreground ${serviceArgs}";
      # Wait after a failure, hoping that the display environment is ready after waiting
      RestartSec = 2;
      Restart = "always";
    };
  };

  mkVirtualBoxUserX11OnlyService =
    serviceArgs: verbose:
    (mkVirtualBoxUserService serviceArgs verbose)
    // {
      unitConfig.ConditionEnvironment = "XDG_SESSION_TYPE=x11";
    };
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "virtualisation"
        "virtualbox"
        "guest"
        "draganddrop"
      ]
      [
        "virtualisation"
        "virtualbox"
        "guest"
        "dragAndDrop"
      ]
    )
  ];

  options.virtualisation.virtualbox.guest = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable the VirtualBox service and other guest additions.";
    };

    clipboard = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable clipboard support.";
    };

    seamless = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable seamless mode. When activated windows from the guest appear next to the windows of the host.";
    };

    dragAndDrop = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to enable drag and drop support.";
    };

    verbose = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to verbose logging for guest services.";
    };

    vboxsf = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to load vboxsf";
    };

    use3rdPartyModules = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Whether to use the kernel modules provided by VirtualBox instead of the ones from the upstream kernel.";
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = pkgs.stdenv.hostPlatform.isx86 || pkgs.stdenv.hostPlatform.isAarch64;
            message = "Virtualbox not currently supported on ${pkgs.stdenv.hostPlatform.system}";
          }
        ];

        environment.systemPackages = [ kernel.virtualboxGuestAdditions ];

        boot.extraModulePackages = lib.mkIf cfg.use3rdPartyModules [ kernel.virtualboxGuestAdditions ];

        systemd.services.virtualbox = {
          description = "VirtualBox Guest Services";

          wantedBy = [ "multi-user.target" ];
          requires = [ "dev-vboxguest.device" ];
          after = [ "dev-vboxguest.device" ];

          unitConfig.ConditionVirtualization = "oracle";

          serviceConfig.ExecStart = "@${kernel.virtualboxGuestAdditions}/bin/VBoxService VBoxService --foreground";
        };

        services.udev.extraRules = ''
          # /dev/vboxuser is necessary for VBoxClient to work.  Maybe we
          # should restrict this to logged-in users.
          KERNEL=="vboxuser",  OWNER="root", GROUP="root", MODE="0666"

          # Allow systemd dependencies on vboxguest.
          SUBSYSTEM=="misc", KERNEL=="vboxguest", TAG+="systemd"
        '';

        systemd.user.services.virtualboxClientVmsvga = mkVirtualBoxUserService "--vmsvga-session" cfg.verbose;
      }
      (lib.mkIf cfg.vboxsf {
        boot.supportedFilesystems = [ "vboxsf" ];
        boot.initrd.supportedFilesystems = [ "vboxsf" ];

        users.groups.vboxsf.gid = config.ids.gids.vboxsf;
      })
      (lib.mkIf cfg.clipboard {
        systemd.user.services.virtualboxClientClipboard = mkVirtualBoxUserService "--clipboard" cfg.verbose;
      })
      (lib.mkIf cfg.seamless {
        systemd.user.services.virtualboxClientSeamless = mkVirtualBoxUserX11OnlyService "--seamless" cfg.verbose;
      })
      (lib.mkIf cfg.dragAndDrop {
        systemd.user.services.virtualboxClientDragAndDrop = mkVirtualBoxUserService "--draganddrop" cfg.verbose;
      })
    ]
  );
}
