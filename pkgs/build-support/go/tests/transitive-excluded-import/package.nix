{
  buildGoModule,
  testers,
}:

# The main package imports `dep`, which has no Go files for this platform.
# The build must fail, and must not skip the main package.
testers.testBuildFailure' {
  drv = buildGoModule {
    name = "transitive-excluded-import";
    src = ./.;
    vendorHash = null;
  };
  expectedBuilderLogEntries = [
    "imports transitive-excluded-import/dep: build constraints exclude all Go files in"
  ];
}
