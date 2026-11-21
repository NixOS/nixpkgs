{
  lib,
  callPackage,
  makeSetupHook,
  iconConvTools,
}:
makeSetupHook {
  name = "install-icons-hook";
  propagatedBuildInputs = [
    iconConvTools
  ];

  passthru.tests = lib.filterAttrs (_: lib.isDerivation) (callPackage ./tests.nix { });

  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.RossSmyth ];
  };
} ./icon-install-hook.sh
