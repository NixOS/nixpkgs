{
  lib,
  makeSetupHook,
  installShellFiles,
}:

makeSetupHook {
  name = "shellCompletionHook";
  propagatedNativeBuildInputs = [
    installShellFiles
  ];
  meta = {
    description = "Install shell completions";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
} ./hook.sh
