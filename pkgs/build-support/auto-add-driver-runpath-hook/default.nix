{ addDriverRunpath, makeSetupHook }:

makeSetupHook {
  name = "auto-add-driver-runpath-hook";
  propagatedBuildInputs = [ addDriverRunpath ];
} ./auto-add-driver-runpath-hook.sh
