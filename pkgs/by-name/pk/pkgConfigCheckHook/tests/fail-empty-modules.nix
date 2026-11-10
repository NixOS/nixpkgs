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
    name = "pkg-config-check-hook--fail-empty-modules";

    strictDeps = true;
    __structuredAttrs = true;

    # src is required to be passed to mkDerivation
    src = null;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      touch $out

      runHook postInstall
    '';

    # pkgConfigModules is intentionally not set
    nativeInstallCheckInputs = [ pkgConfigCheckHook ];
    doInstallCheck = true;

    meta.platforms = lib.platforms.all;
  };
  expectedBuilderLogEntries = [
    "pkgConfigCheckHook: pkgConfigModules is empty or unset"
  ];
}
