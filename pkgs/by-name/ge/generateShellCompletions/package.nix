{
  lib,
  stdenvNoCC,
  callPackage,
  makeSetupHook,
  installShellFiles,
}:

# See the header comment in ./setup-hook.sh for example usage.
makeSetupHook {
  name = "generate-shell-completions-hook";
  propagatedBuildInputs = [ installShellFiles ];
  substitutions = {
    # The hook refuses to load unless it is a native build input.  There its
    # host platform is the build platform, and its target platform is the host
    # platform of the package that uses it.
    canExecuteHost = lib.boolToString (stdenvNoCC.hostPlatform.canExecute stdenvNoCC.targetPlatform);
  };
  passthru.tests = lib.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./tests;
  };
  meta = {
    description = "Setup hook that generates shell completions by running a program of the package";
    maintainers = with lib.maintainers; [ yiyu ];
    license = lib.licenses.mit;
  };
} ./setup-hook.sh
