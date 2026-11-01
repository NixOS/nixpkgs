{
  lib,
  makeSetupHook,
  installShellFiles,
  makeWrapper,
  nodejs,
  jq,
}:

makeSetupHook {
  name = "nodejs-install-executables";
  propagatedBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  substitutions = {
    hostNode = "${nodejs}/bin/node";
    jq = "${lib.getExe jq}";
  };
  meta.license = lib.licenses.mit;
} ./hook.sh
