{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-java";
  version = "1.39.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-java";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H9fce2JIA1w2w0oFvQ4Zrl6XpS8T5AGylvhTJ7cIA2c=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags = [
    "-skip=^${
      lib.concatStringsSep "$|^" [
        "TestLanguage"
        "TestLanguagePublished"
        "TestLanguageLocal"
        "TestLanguageExtraTypes"
        "TestPluginsAndDependencies_vendored"
        "TestPluginsAndDependencies_subdir"
        "TestPluginsAndDependencies_moduleMode"
      ]
    }$"
  ];

  sourceRoot = "source";
  vendorHash = "sha256-XIM1TU7iD1FAu2giS6W+/nH9mDy5gDdmYSZPunawyAg=";

  subPackages = [ "pkg/cmd/pulumi-language-java" ];

  meta = {
    description = "Language host for Pulumi programs written in Java";
    homepage = "https://github.com/pulumi/pulumi-java";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wormt ];
    mainProgram = "pulumi-language-java";
    platforms = lib.platforms.all;
  };
})
