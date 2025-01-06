{
  stdenvNoCC,
  lib,
  php,
}:

let
  mkComposerVendorOverride =
    /*
      We cannot destruct finalAttrs since the attrset below is used to construct it
      and Nix currently does not support lazy attribute names.
      {
      php ? null,
      composer ? null,
      composerLock ? "composer.lock",
      src,
      vendorHash,
      ...
      }@finalAttrs:
    */
    finalAttrs: previousAttrs:

    let
      phpDrv = finalAttrs.php or php;
      composer = finalAttrs.composer or phpDrv.packages.composer;
    in
    assert (lib.assertMsg (previousAttrs ? src) "mkComposerVendor expects src argument.");
    assert (lib.assertMsg (previousAttrs ? vendorHash) "mkComposerVendor expects vendorHash argument.");
    assert (lib.assertMsg (previousAttrs ? version) "mkComposerVendor expects version argument.");
    assert (lib.assertMsg (previousAttrs ? pname) "mkComposerVendor expects pname argument.");
    {
      composerNoDev = previousAttrs.composerNoDev or true;
      composerNoPlugins = previousAttrs.composerNoPlugins or true;
      composerNoScripts = previousAttrs.composerNoScripts or true;
      composerStrictValidation = previousAttrs.composerStrictValidation or true;

      name = "${previousAttrs.pname}-${previousAttrs.version}-composer-repository";

      # See https://github.com/NixOS/nix/issues/6660
      dontPatchShebangs = previousAttrs.dontPatchShebangs or true;

      nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [
        composer
        phpDrv
        phpDrv.composerHooks2.composerVendorHook
      ];

      buildInputs = previousAttrs.buildInputs or [ ];

      strictDeps = previousAttrs.strictDeps or true;

      # Should we keep these empty phases?
      configurePhase =
        previousAttrs.configurePhase or ''
          runHook preConfigure

          runHook postConfigure
        '';

      buildPhase =
        previousAttrs.buildPhase or ''
          runHook preBuild

          runHook postBuild
        '';

      doCheck = previousAttrs.doCheck or true;
      checkPhase =
        previousAttrs.checkPhase or ''
          runHook preCheck

          runHook postCheck
        '';

      installPhase =
        previousAttrs.installPhase or ''
          runHook preInstall

          runHook postInstall
        '';

      doInstallCheck = previousAttrs.doInstallCheck or false;
      installCheckPhase =
        previousAttrs.installCheckPhase or ''
          runHook preInstallCheck

          runHook postInstallCheck
        '';

      outputHashMode = "recursive";
      outputHashAlgo =
        if (finalAttrs ? vendorHash && finalAttrs.vendorHash != "") then null else "sha256";
      outputHash = finalAttrs.vendorHash or "";
    };
in
args: (stdenvNoCC.mkDerivation args).overrideAttrs mkComposerVendorOverride
