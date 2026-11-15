{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-java";
  version = "1.40.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-java";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BdCJWt2BuoMgOsQeSt08kRSoYw5FdPQtzTR9lHd3m34=";
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
  vendorHash = "sha256-SdGH5EVxxWV2MfeyGvUopyqt1tBbB+lLSzR9DYsH5HQ=";

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
