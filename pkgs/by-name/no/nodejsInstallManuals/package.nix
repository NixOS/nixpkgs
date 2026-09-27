{
  lib,
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
  meta.license = lib.licenses.mit;
} ./hook.sh
