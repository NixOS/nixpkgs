# Updates the vscode setting file base on a nix expression
# should run from the workspace root.
{
  writeShellScriptBin,
  lib,
  jq,
}:
##User Input
{
  settings ? { },
  # if marked as true will create an empty json file if does not exist
  createIfDoesNotExists ? true,
  vscodeSettingsFile ? ".vscode/settings.json",
  userSettingsFolder ? "",
  symlinkFromUserSetting ? false,
}:
let

  updateVSCodeSettingsCmd = ''
    (
      echo 'updateSettings.nix: Updating ${vscodeSettingsFile}...'
      oldSettings=$(cat ${vscodeSettingsFile})
      echo $oldSettings' ${builtins.toJSON settings}' | ${jq}/bin/jq -s add > ${vscodeSettingsFile}
    )'';

  createEmptySettingsCmd = ''mkdir -p .vscode && echo "{}" > ${vscodeSettingsFile}'';
  fileName = builtins.baseNameOf vscodeSettingsFile;
  symlinkFromUserSettingCmd = lib.optionalString symlinkFromUserSetting ''&& mkdir -p "${userSettingsFolder}" && ln -sfv "$(pwd)/${vscodeSettingsFile}" "${userSettingsFolder}/" '';
in

writeShellScriptBin ''vscodeNixUpdate-${lib.removeSuffix ".json" (fileName)}'' (
  lib.optionalString (settings != { }) (
    if createIfDoesNotExists then
      ''
        [ ! -f "${vscodeSettingsFile}" ] && ${createEmptySettingsCmd}
        ${updateVSCodeSettingsCmd} ${symlinkFromUserSettingCmd}
      ''
    else
      ''
        [ -f "${vscodeSettingsFile}" ] && ${updateVSCodeSettingsCmd} ${symlinkFromUserSettingCmd}
      ''
  )
)
