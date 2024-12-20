{
  deviceNameStrategy,
  glibc,
  jq,
  lib,
  mounts,
  nvidia-container-toolkit,
  nvidia-driver,
  runtimeShell,
  writeScriptBin,
}:
let
  mkMount =
    {
      hostPath,
      containerPath,
      mountOptions,
    }:
    {
      inherit hostPath containerPath;
      options = mountOptions;
    };
  mountToCommand =
    mount:
    "additionalMount \"${mount.hostPath}\" \"${mount.containerPath}\" '${builtins.toJSON mount.mountOptions}'";
  mountsToCommands =
    mounts:
    if (builtins.length mounts) == 0 then
      "cat"
    else
      (lib.strings.concatMapStringsSep " | \\\n" mountToCommand mounts);
in
writeScriptBin "nvidia-cdi-generator" ''
  #! ${runtimeShell}

  function cdiGenerate {
    ${lib.getExe' nvidia-container-toolkit "nvidia-ctk"} cdi generate \
      --format json \
      --device-name-strategy ${deviceNameStrategy} \
      --ldconfig-path ${lib.getExe' glibc "ldconfig"} \
      --library-search-path ${lib.getLib nvidia-driver}/lib \
      --nvidia-ctk-path ${lib.getExe' nvidia-container-toolkit "nvidia-ctk"}
  }

  function additionalMount {
    local hostPath="$1"
    local containerPath="$2"
    local mountOptions="$3"
    if [ -e "$hostPath" ]; then
      ${lib.getExe jq} ".containerEdits.mounts[.containerEdits.mounts | length] = { \"hostPath\": \"$hostPath\", \"containerPath\": \"$containerPath\", \"options\": $mountOptions }"
    else
      echo "Mount $hostPath ignored: could not find path in the host machine" >&2
      cat
    fi
  }

  cdiGenerate |
    ${mountsToCommands mounts} > $RUNTIME_DIRECTORY/nvidia-container-toolkit.json
''
