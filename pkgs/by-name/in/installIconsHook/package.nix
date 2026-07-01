{
  lib,
  makeSetupHook,
  iconConvTools,
}:
makeSetupHook {
  name = "install-icons-hook";
  propagatedBuildInputs = [
    iconConvTools
  ];
  __structuredAttrs = true;
  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.RossSmyth ];
  };
} ./icon-install-hook.sh
