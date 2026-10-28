{
  # keep-sorted start
  bash,
  lib,
  makeSetupHook,
  python3,
  # keep-sorted end
}:
/**
  See https://www.jetbrains.com/help/pycharm/2026.2/cython-speedups.html
*/
makeSetupHook {
  name = "cython-debug-speedups-hook";
  substitutions = {
    shell = lib.getExe bash;
    python = python3.interpreter;
  };
  meta = {
    description = "Setup hook that applies Cython-based debugger speedups from JetBrains";
    teams = [ lib.teams.jetbrains ];
  };
} ./cython-debug-speedups-hook.sh
