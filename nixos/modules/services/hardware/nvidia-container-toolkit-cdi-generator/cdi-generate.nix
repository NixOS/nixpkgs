{
  addDriverRunpath,
  glibc,
  jq,
  lib,
  nvidia-container-toolkit,
  nvidia-driver,
  runtimeShell,
  writeScriptBin,
}:
let
  mountOptions = { options = ["ro" "nosuid" "nodev" "bind"]; };
  mounts = [
    # FIXME: Making /usr mounts optional
    { hostPath = lib.getExe' nvidia-driver "nvidia-cuda-mps-control";
      containerPath = "/usr/bin/nvidia-cuda-mps-control"; }
    { hostPath = lib.getExe' nvidia-driver "nvidia-cuda-mps-server";
      containerPath = "/usr/bin/nvidia-cuda-mps-server"; }
    { hostPath = lib.getExe' nvidia-driver "nvidia-debugdump";
      containerPath = "/usr/bin/nvidia-debugdump"; }
    { hostPath = lib.getExe' nvidia-driver "nvidia-powerd";
      containerPath = "/usr/bin/nvidia-powerd"; }
    { hostPath = lib.getExe' nvidia-driver "nvidia-smi";
      containerPath = "/usr/bin/nvidia-smi"; }
    { hostPath = lib.getExe' nvidia-container-toolkit "nvidia-ctk";
      containerPath = "/usr/bin/nvidia-ctk"; }
    { hostPath = "${lib.getLib glibc}/lib";
      containerPath = "${lib.getLib glibc}/lib"; }

    # FIXME: use closureinfo
    {
      hostPath = addDriverRunpath.driverLink;
      containerPath = addDriverRunpath.driverLink;
    }
    { hostPath = "${lib.getLib glibc}/lib";
      containerPath = "${lib.getLib glibc}/lib"; }
    { hostPath = "${lib.getLib glibc}/lib64";
      containerPath = "${lib.getLib glibc}/lib64"; }
  ];
  jqAddMountExpression = ".containerEdits.mounts[.containerEdits.mounts | length] |= . +";
  mountsToJq = lib.concatMap
    (mount:
      ["${lib.getExe jq} '${jqAddMountExpression} ${builtins.toJSON (mount // mountOptions)}'"])
    mounts;
in
writeScriptBin "nvidia-cdi-generator"
''
#! ${runtimeShell}

function cdiGenerate {
  ${lib.getExe' nvidia-container-toolkit "nvidia-ctk"} cdi generate \
    --format json \
    --ldconfig-path ${lib.getExe' glibc "ldconfig"} \
    --library-search-path ${lib.getLib nvidia-driver}/lib \
    --nvidia-ctk-path ${lib.getExe' nvidia-container-toolkit "nvidia-ctk"}
}

cdiGenerate | \
  ${lib.concatStringsSep " | " mountsToJq} > $RUNTIME_DIRECTORY/nvidia-container-toolkit.json
''
