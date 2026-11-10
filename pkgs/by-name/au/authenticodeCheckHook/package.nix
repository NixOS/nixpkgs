{
  lib,
  makeSetupHook,
  pesign,
}:

makeSetupHook {
  name = "authenticode-check-hook";

  substitutions = {
    pesigcheck = lib.getExe' pesign "pesigcheck";
  };

  meta = {
    description = "Setup hook for verifying Authenticode signatures";
    inherit (pesign.meta) platforms;
    teams = [ lib.teams.boot-security ];
    license = lib.licenses.mit;
  };
} ./setup-hook.bash
