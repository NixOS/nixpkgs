{
  lib,
  runCommand,
  pulumi,
  jq,
}:
{
  package,
  name ? lib.removePrefix "pulumi-" (lib.getName package),
  version ? lib.getVersion package,
}:
runCommand "pulumi-resource-${name}-schema-version-check"
  {
    resourceName = name;
    expectedVersion = if version != null then version else "null";
    nativeBuildInputs = [
      jq
      pulumi
      package
    ];
    env = {
      PULUMI_SKIP_UPDATE_CHECK = "1";
      PULUMI_DISABLE_AUTOMATIC_PLUGIN_ACQUISITION = "1";
    };
    __darwinAllowLocalNetworking = true;
    meta.timeout = 120;
  }
  ''
    actualVersion=$(pulumi package get-schema -- "$resourceName" | jq -j .version)
    if [[ $expectedVersion != "$actualVersion" ]]; then
      echo "Expected schema version $expectedVersion, but got $actualVersion" >&2
      false
    fi
    mkdir -p "$out"
  ''
