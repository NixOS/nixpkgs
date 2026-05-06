{
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
    jq = "${jq}/bin/jq";
  };
} ./hook.sh
