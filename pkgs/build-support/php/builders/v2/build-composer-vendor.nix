{
  stdenvNoCC,
  lib,
  php,
}@toplevel:

let
  mkComposerVendorOverride =
    finalAttrs:
    {
      php ? finalAttrs.php or toplevel.php,
      composer ? finalAttrs.php.packages.composer or toplevel.php.packages.composer,
      composerLock ? finalAttrs.composerLock or null,
      vendorHash ? finalAttrs.vendorHash or "",
      composerNoDev ? finalAttrs.composerNoDev or true,
      composerNoPlugins ? finalAttrs.composerNoPlugins or true,
      composerNoScripts ? finalAttrs.composerNoScripts or true,
      composerStrictValidation ? finalAttrs.composerStrictValidation or true,
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
