{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-java";
  version = "1.37.2";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-java";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tOon5LXGx6rr8epJ1PY7slAllG2jv84i8OrvaA4fcmE=";
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
  vendorHash = "sha256-Gr1gO7t5Pv1hb9uifAWEmxtVycjyEg2aFysDEBuSx0w=";

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
