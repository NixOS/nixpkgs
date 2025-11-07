{
  nix-update-script,
  stdenvNoCC,
  lib,
  php,
}@toplevel:

let
  buildComposerProjectOverride =
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
      strictDeps ? true,
      patches ? [ ],
      doCheck ? true,
      doInstallCheck ? true,
      dontCheckForBrokenSymlinks ? true,
      passthru ? { },
      meta ? { },
      ...
    }@args:
    {
      inherit
        patches
        strictDeps
        doCheck
        doInstallCheck
        dontCheckForBrokenSymlinks
        ;

      nativeBuildInputs = nativeBuildInputs ++ [
        composer
        php
        php.composerHooks2.composerInstallHook
      ];

      buildInputs = buildInputs ++ [ php ];

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

      composerVendor =
        args.composerVendor or (php.mkComposerVendor {
          inherit (finalAttrs)
            pname
            src
            vendorHash
            version
            ;
          inherit
            php
            composer
            composerLock
            composerNoDev
            composerNoPlugins
            composerNoScripts
            composerStrictValidation
            dontCheckForBrokenSymlinks
            ;
        });

      # Projects providing a lockfile from upstream can be automatically updated.
      passthru = passthru // {
        updateScript =
          args.passthru.updateScript
            or (if finalAttrs.composerVendor.composerLock == null then nix-update-script { } else null);
      };

      meta = meta // {
        platforms = lib.platforms.all;
      };
    };
in
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  extendDrvArgs = buildComposerProjectOverride;
}
