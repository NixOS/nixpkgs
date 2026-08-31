{
  lib,
  callPackage,
  makeSetupHook
}:

# used installFonts, installShellFiles as reference
# See the header comment in ./setup-hook.sh for example usage.
makeSetupHook {
  name = "install-agent-skills";
  meta = {
    description = "Tools to install Agent skills into the correct directories";
    license = lib.licenses.mit;
  };
} ./setup-hook.sh
