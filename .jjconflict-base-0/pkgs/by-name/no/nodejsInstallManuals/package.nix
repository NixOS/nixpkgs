{
  makeSetupHook,
  installShellFiles,
  jq,
}:

makeSetupHook {
  name = "nodejs-install-manuals";
  propagatedBuildInputs = [ installShellFiles ];
  substitutions = {
    jq = "${jq}/bin/jq";
  };
} ./hook.sh
