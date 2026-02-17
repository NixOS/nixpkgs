{
  stdenvNoCC,
  lib,
  php,
}@toplevel:

let
  mkComposerVendorOverride =
    finalAttrs:
    {
      php ? toplevel.php,
      composer ? php.packages.composer,
      composerLock ? null,
      vendorHash ? "",
      composerNoDev ? true,
      composerNoPlugins ? true,
      composerNoScripts ? true,
      composerStrictValidation ? true,
      buildInputs ? [ ],
      nativeBuildInputs ? [ ],
      dontPatchShebangs ? true,
      strictDeps ? true,
      doCheck ? true,
      doInstallCheck ? false,
      dontCheckForBrokenSymlinks ? true,
      ...
    }@args:
    assert (lib.assertMsg (args ? pname) "mkComposerVendor expects pname argument.");
    assert (lib.assertMsg (args ? version) "mkComposerVendor expects version argument.");
    assert (lib.assertMsg (args ? src) "mkComposerVendor expects src argument.");
    {
      name = "${args.pname}-composer-vendor-${args.version}";

      # See https://github.com/NixOS/nix/issues/6660
      inherit dontPatchShebangs;

      inherit
        buildInputs
        strictDeps
        doCheck
        ;

      nativeBuildInputs = nativeBuildInputs ++ [
        composer
        php
        php.composerHooks2.composerVendorHook
      ];

      # Should we keep these empty phases?
      configurePhase =
        args.configurePhase or ''
          runHook preConfigure

          runHook postConfigure
        '';

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          runHook postBuild
        '';

      checkPhase =
        args.checkPhase or ''
          runHook preCheck

          runHook postCheck
        '';

      installPhase =
        args.installPhase or ''
          runHook preInstall

          runHook postInstall
        '';

      installCheckPhase =
        args.installCheckPhase or ''
          runHook preInstallCheck

          runHook postInstallCheck
        '';

      outputHashMode = "recursive";
      outputHashAlgo =
        if (finalAttrs ? vendorHash && finalAttrs.vendorHash != "") then null else "sha256";
      outputHash = vendorHash;
    };
in
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  extendDrvArgs = mkComposerVendorOverride;
}
