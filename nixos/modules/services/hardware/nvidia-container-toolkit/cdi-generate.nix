{
  glibc,
  jq,
  lib,
  mounts,
  nvidia-container-toolkit,
  nvidia-driver,
  runtimeShell,
  writeScriptBin,
}: let
  mkMount = {hostPath, containerPath, mountOptions}: {
    inherit hostPath containerPath;
    options = mountOptions;
  };
  jqAddMountExpression = ".containerEdits.mounts[.containerEdits.mounts | length] |= . +";
  allJqMounts = lib.concatMap
    (mount:
      ["${lib.getExe jq} '${jqAddMountExpression} ${builtins.toJSON (mkMount mount)}'"])
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
  ${lib.concatStringsSep " | " allJqMounts} > $RUNTIME_DIRECTORY/nvidia-container-toolkit.json
''
