{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.bumblebee;

  kernel = config.boot.kernelPackages;

  useNvidia = cfg.driver == "nvidia";

  bumblebee = pkgs.bumblebee.override {
    inherit useNvidia;
    useDisplayDevice = cfg.connectDisplay;
  };

  useBbswitch = cfg.pmMethod == "bbswitch" || cfg.pmMethod == "auto" && useNvidia;

  primus = pkgs.primus.override {
    inherit useNvidia;
  };

in

{

  options = {
    hardware.bumblebee = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable the bumblebee daemon to manage Optimus hybrid video cards.
          This should power off secondary GPU until its use is requested
          by running an application with optirun.
        '';
      };

      group = lib.mkOption {
        default = "wheel";
        example = "video";
        type = lib.types.str;
        description = "Group for bumblebee socket";
      };

      connectDisplay = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Set to true if you intend to connect your discrete card to a
          monitor. This option will set up your Nvidia card for EDID
          discovery and to turn on the monitor signal.

          Only nvidia driver is supported so far.
        '';
      };

      driver = lib.mkOption {
        default = "nvidia";
        type = lib.types.enum [
          "nvidia"
          "nouveau"
        ];
        description = ''
          Set driver used by bumblebeed. Supported are nouveau and nvidia.
        '';
      };

      pmMethod = lib.mkOption {
        default = "auto";
        type = lib.types.enum [
          "auto"
          "bbswitch"
          "switcheroo"
          "none"
        ];
        description = ''
          Set preferred power management method for unused card.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    boot.blacklistedKernelModules = [
      "nvidia-drm"
      "nvidia"
      "nouveau"
    ];
    boot.kernelModules = lib.optional useBbswitch "bbswitch";
    boot.extraModulePackages =
      lib.optional useBbswitch kernel.bbswitch ++ lib.optional useNvidia kernel.nvidia_x11.bin;

    environment.systemPackages = [
      bumblebee
      primus
    ];

    systemd.services.bumblebeed = {
      description = "Bumblebee Hybrid Graphics Switcher";
      wantedBy = [ "multi-user.target" ];
      before = [ "display-manager.service" ];
      serviceConfig = {
        ExecStart = "${bumblebee}/bin/bumblebeed --use-syslog -g ${cfg.group} --driver ${cfg.driver} --pm-method ${cfg.pmMethod}";
      };
    };
  };
}
