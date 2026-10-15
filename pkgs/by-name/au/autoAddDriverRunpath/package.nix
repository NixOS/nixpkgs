{
  lib,
  addDriverRunpath,
  autoFixElfFiles,
  makeSetupHook,
}:

makeSetupHook {
  name = "auto-add-driver-runpath-hook";
  propagatedBuildInputs = [
    addDriverRunpath
    autoFixElfFiles
  ];
  meta.license = lib.licenses.mit;
} ./auto-add-driver-runpath-hook.sh
