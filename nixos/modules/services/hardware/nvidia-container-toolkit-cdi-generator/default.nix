{ config, lib, pkgs, ... }:

{

  options = {

    hardware.nvidia-container-toolkit-cdi-generator.enable = lib.mkOption {
      default = false;
      internal = true;
      visible = false;
      type = lib.types.bool;
      description = lib.mdDoc ''
        Enable dynamic CDI configuration for NVidia devices by running
        nvidia-container-toolkit on boot.
      '';
    };

  };

  config = {

    systemd.services.nvidia-container-toolkit-cdi-generator = lib.mkIf config.hardware.nvidia-container-toolkit-cdi-generator.enable {
      description = "Container Device Interface (CDI) for Nvidia generator";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        RuntimeDirectory = "cdi";
        RemainAfterExit = true;
        ExecStart =
          let
            script = pkgs.callPackage ./cdi-generate.nix { nvidia-driver = config.hardware.nvidia.package; };
          in
          lib.getExe script;
        Type = "oneshot";
      };
    };

  };

}
