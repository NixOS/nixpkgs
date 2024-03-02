{ config, lib, pkgs }: let
  mountOptions = { options = ["ro" "nosuid" "nodev" "bind"]; };
  mounts = [
    { hostPath = "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-cuda-mps-control";
      containerPath = "/usr/bin/nvidia-cuda-mps-control"; }
    { hostPath = "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-cuda-mps-server";
      containerPath = "/usr/bin/nvidia-cuda-mps-server"; }
    { hostPath = "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-debugdump";
      containerPath = "/usr/bin/nvidia-debugdump"; }
    { hostPath = "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-powerd";
      containerPath = "/usr/bin/nvidia-powerd"; }
    { hostPath = "${lib.getBin config.hardware.nvidia.package}/bin/nvidia-smi";
      containerPath = "/usr/bin/nvidia-smi"; }
    { hostPath = "${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk";
      containerPath = "/usr/bin/nvidia-ctk"; }
    { hostPath = "${pkgs.glibc}/lib";
      containerPath = "${pkgs.glibc}/lib"; }
    { hostPath = "${pkgs.glibc}/lib64";
      containerPath = "${pkgs.glibc}/lib64"; }
  ];
  jqAddMountExpression = ".containerEdits.mounts[.containerEdits.mounts | length] |= . +";
  mountsToJq = lib.concatMap
    (mount:
      ["${pkgs.jq}/bin/jq '${jqAddMountExpression} ${builtins.toJSON (mount // mountOptions)}'"])
    mounts;
in ''
#! ${pkgs.runtimeShell}

function cdiGenerate {
  ${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk cdi generate \
    --format json \
    --ldconfig-path ${pkgs.glibc.bin}/bin/ldconfig \
    --library-search-path ${config.hardware.nvidia.package}/lib \
    --nvidia-ctk-path ${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk
}

cdiGenerate | \
  ${lib.concatStringsSep " | " mountsToJq} > $RUNTIME_DIRECTORY/nvidia-container-toolkit.json
''
