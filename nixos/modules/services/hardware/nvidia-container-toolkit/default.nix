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
          Enable dynamic CDI configuration for Nvidia devices by running
          nvidia-container-toolkit on boot.
        '';
      };

      mounts = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule mountType);
        default = [];
        description = "Mounts to be added to every container under the Nvidia CDI profile.";
      };

      mount-nvidia-executables = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Mount executables nvidia-smi, nvidia-cuda-mps-control, nvidia-cuda-mps-server,
          nvidia-debugdump, nvidia-powerd and nvidia-ctk on containers.
        '';
      };

      device-name-strategy = lib.mkOption {
        default = "index";
        type = lib.types.enum [ "index" "uuid" "type-index" ];
        description = ''
          Specify the strategy for generating device names,
          passed to `nvidia-ctk cdi generate`. This will affect how
          you reference the device using `nvidia.com/gpu=` in
          the container runtime.
        '';
      };

      mount-nvidia-docker-1-directories = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Mount nvidia-docker-1 directories on containers: /usr/local/nvidia/lib and
          /usr/local/nvidia/lib64.
        '';
      };

      package = lib.mkPackageOption pkgs "nvidia-container-toolkit" { };
    };

  };

  config = {

    virtualisation.docker.daemon.settings = lib.mkIf
      (config.hardware.nvidia-container-toolkit.enable &&
       (lib.versionAtLeast config.virtualisation.docker.package.version "25")) {
         features.cdi = true;
       };

    hardware.nvidia-container-toolkit.mounts = let
      nvidia-driver = config.hardware.nvidia.package;
    in (lib.mkMerge [
      [{ hostPath = pkgs.addDriverRunpath.driverLink;
         containerPath = pkgs.addDriverRunpath.driverLink; }
       { hostPath = "${lib.getLib nvidia-driver}/etc";
         containerPath = "${lib.getLib nvidia-driver}/etc"; }
       { hostPath = "${lib.getLib nvidia-driver}/share";
         containerPath = "${lib.getLib nvidia-driver}/share"; }
       { hostPath = "${lib.getLib pkgs.glibc}/lib";
         containerPath = "${lib.getLib pkgs.glibc}/lib"; }
       { hostPath = "${lib.getLib pkgs.glibc}/lib64";
         containerPath = "${lib.getLib pkgs.glibc}/lib64"; }]
      (lib.mkIf config.hardware.nvidia-container-toolkit.mount-nvidia-executables
        [{ hostPath = lib.getExe' nvidia-driver "nvidia-cuda-mps-control";
           containerPath = "/usr/bin/nvidia-cuda-mps-control"; }
         { hostPath = lib.getExe' nvidia-driver "nvidia-cuda-mps-server";
           containerPath = "/usr/bin/nvidia-cuda-mps-server"; }
         { hostPath = lib.getExe' nvidia-driver "nvidia-debugdump";
           containerPath = "/usr/bin/nvidia-debugdump"; }
         { hostPath = lib.getExe' nvidia-driver "nvidia-powerd";
           containerPath = "/usr/bin/nvidia-powerd"; }
         { hostPath = lib.getExe' nvidia-driver "nvidia-smi";
           containerPath = "/usr/bin/nvidia-smi"; }])
      # nvidia-docker 1.0 uses /usr/local/nvidia/lib{,64}
      #   e.g.
      #     - https://gitlab.com/nvidia/container-images/cuda/-/blob/e3ff10eab3a1424fe394899df0e0f8ca5a410f0f/dist/12.3.1/ubi9/base/Dockerfile#L44
      #     - https://github.com/NVIDIA/nvidia-docker/blob/01d2c9436620d7dde4672e414698afe6da4a282f/src/nvidia/volumes.go#L104-L173
      (lib.mkIf config.hardware.nvidia-container-toolkit.mount-nvidia-docker-1-directories
        [{ hostPath = "${lib.getLib nvidia-driver}/lib";
           containerPath = "/usr/local/nvidia/lib"; }
         { hostPath = "${lib.getLib nvidia-driver}/lib";
           containerPath = "/usr/local/nvidia/lib64"; }])
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
              nvidia-container-toolkit = config.hardware.nvidia-container-toolkit.package;
              nvidia-driver = config.hardware.nvidia.package;
              deviceNameStrategy = config.hardware.nvidia-container-toolkit.device-name-strategy;
            };
          in
          lib.getExe script;
        Type = "oneshot";
      };
    };

  };

}
