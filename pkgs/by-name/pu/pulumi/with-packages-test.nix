{
  runCommand,
  pulumi,
  buildPackages,
}:
runCommand "pulumi-with-packages-test"
  {
    # We are testing withPackages implementation, so we don’t really care that
    # pulumi packages come from buildPackages, but that allows us to test that
    # pulumi can find wrapped packages.
    pulumiWithStd = buildPackages.pulumi.withPackages (ps: [ ps.pulumi-std ]);

    # Also test that withPackages succeeds with an empty list.
    pulumiWithoutPackages = pulumi.withPackages (_: [ ]);

    env = {
      PULUMI_SKIP_UPDATE_CHECK = "1";
      PULUMI_DISABLE_AUTOMATIC_PLUGIN_ACQUISITION = "1";
    };

    __darwinAllowLocalNetworking = true;
  }
  ''
    test -e "$pulumiWithoutPackages/bin/pulumi"
    "$pulumiWithStd/bin/pulumi" package get-schema std >/dev/null
    mkdir -p "$out"
  ''
