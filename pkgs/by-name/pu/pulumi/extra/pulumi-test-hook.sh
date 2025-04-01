# shellcheck shell=bash

appendToVar preCheckHooks pulumiTestHook

pulumiTestHook() {
    local tmpdir
    tmpdir=$(mktemp -d)
    export USER=${USER-nixbld} HOME=${HOME-$tmpdir}
    export PULUMI_HOME=$tmpdir/.pulumi
    export PULUMI_CONFIG_PASSPHRASE=5up3r53cr37
    export PULUMI_SKIP_UPDATE_CHECK=1
    export PULUMI_DISABLE_AUTOMATIC_PLUGIN_ACQUISITION=1
    pulumi login "file://$tmpdir"
    pulumi stack init -- "${pulumiStackName-nixpkgs}"
}
