{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-java";
  version = "1.36.2";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-java";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y7gaZerDYfD+t2xMK3Iw9q8v3MRdIZMt2/KEnpEj/l8=";
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
  vendorHash = "sha256-gq1+k5KyziNUR0XTbEJJ5m0QDmMH4WNbA6At25a6DnM=";

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
