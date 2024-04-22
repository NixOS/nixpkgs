{ config, lib, pkgs, ... }:

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "virtualisation" "containers" "cdi" "dynamic" "nvidia" "enable" ]
      [ "hardware" "nvidia-container-toolkit" "enable" ])
  ];

  options = let
    mountType = {
      options = {
        hostPath = lib.mkOption {
          type = lib.types.str;
          description = "Host path.";
        };
        containerPath = lib.mkOption {
          type = lib.types.str;
          description = "Container path.";
        };
        mountOptions = lib.mkOption {
          default = [ "ro" "nosuid" "nodev" "bind" ];
          type = lib.types.listOf lib.types.str;
          description = "Mount options.";
        };
      };
    };
  in {

    hardware.nvidia-container-toolkit = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable dynamic CDI configuration for NVidia devices by running
          nvidia-container-toolkit on boot.
        '';
      };

      mounts = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule mountType);
        default = [];
        description = "Mounts to be added to every container under the Nvidia CDI profile.";
      };
    };

  };

  config = {

    hardware.nvidia-container-toolkit.mounts = let
      nvidia-driver = config.hardware.nvidia.package;
    in (lib.mkMerge [
      [{ hostPath = pkgs.addDriverRunpath.driverLink;
         containerPath = pkgs.addDriverRunpath.driverLink; }
       { hostPath = "${lib.getLib pkgs.glibc}/lib";
         containerPath = "${lib.getLib pkgs.glibc}/lib"; }
       { hostPath = "${lib.getLib pkgs.glibc}/lib64";
         containerPath = "${lib.getLib pkgs.glibc}/lib64"; }]
    ]);

    systemd.services.nvidia-container-toolkit-cdi-generator = lib.mkIf config.hardware.nvidia-container-toolkit.enable {
      description = "Container Device Interface (CDI) for Nvidia generator";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        RuntimeDirectory = "cdi";
        RemainAfterExit = true;
        ExecStart =
          let
            script = pkgs.callPackage ./cdi-generate.nix {
              inherit (config.hardware.nvidia-container-toolkit) mounts;
              nvidia-driver = config.hardware.nvidia.package;
            };
          in
          lib.getExe script;
        Type = "oneshot";
      };
    };

  };

}
