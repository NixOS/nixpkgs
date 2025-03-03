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
      php ? toplevel.php,
      composer ? toplevel.php.packages.composer,
      composerVendor ? null,
      vendorHash ? null,
      composerLock ? null,
      composerNoDev ? true,
      composerNoPlugins ? true,
      composerNoScripts ? true,
      composerStrictValidation ? true,
      buildInputs ? [ ],
      nativeBuildInputs ? [ ],
      strictDeps ? true,
      patches ? [ ],
      doCheck ? true,
      doInstallCheck ? true,
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
          inherit
            composer
            composerLock
            composerNoDev
            composerNoPlugins
            composerNoScripts
            composerStrictValidation
            vendorHash
            ;
          inherit (finalAttrs)
            patches
            pname
            src
            version
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
