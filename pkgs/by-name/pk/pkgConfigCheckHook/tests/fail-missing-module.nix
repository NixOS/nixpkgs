{
  lib,
  stdenvNoCC,
  testers,
  pkgConfigCheckHook,
}:

testers.testBuildFailure' {
  drv = stdenvNoCC.mkDerivation {
    # explicit pname and version are required for the hook to work but
    # name is manually set to keep drvPath consistent across
    # tests for pkgConfigCheckHook
    pname = "test";
    version = "1.0.0";
    name = "pkg-config-check-hook--fail-missing-module";

    strictDeps = true;
    __structuredAttrs = true;

    # src is required to be passed to mkDerivation
    src = null;
    dontUnpack = true;

    # no .pc file is installed
    installPhase = ''
      runHook preInstall

      touch $out

      runHook postInstall
    '';

    nativeInstallCheckInputs = [ pkgConfigCheckHook ];
    pkgConfigModules = [ "test" ];
    doInstallCheck = true;

    meta.platforms = lib.platforms.all;
  };
  expectedBuilderLogEntries = [
    "pkg-config module test not found"
  ];
}
