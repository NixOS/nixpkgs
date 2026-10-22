{
  stdenvNoCC,
  writeText,
  lib,
  makeBinaryWrapper,
  php,
  cacert,
  nix-update-script,
}:

let
  composerJsonBuilder =
    pluginName: pluginVersion:
    writeText "composer.json" (
      builtins.toJSON {
        name = "nix/plugin";
        description = "Nix Composer plugin";
        license = "MIT";
        require = {
          "${pluginName}" = "${pluginVersion}";
        };
        config = {
          "allow-plugins" = {
            "${pluginName}" = true;
          };
        };
        repositories = [
          {
            type = "path";
            url = "./src";
            options = {
              versions = {
                "${pluginName}" = "${pluginVersion}";
              };
            };
          }
        ];
      }
    );

  buildComposerWithPluginOverride =
    finalAttrs: previousAttrs:

    let
      phpDrv = finalAttrs.php or php;
      composer = finalAttrs.composer or phpDrv.packages.composer;
    in
    {
      composerLock = previousAttrs.composerLock or null;
      composerNoDev = previousAttrs.composerNoDev or true;
      composerNoPlugins = previousAttrs.composerNoPlugins or true;
      composerNoScripts = previousAttrs.composerNoScripts or true;
      composerStrictValidation = previousAttrs.composerStrictValidation or true;
      composerGlobal = true;

      nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [
        composer
        phpDrv
        makeBinaryWrapper
      ];

      buildInputs = (previousAttrs.buildInputs or [ ]) ++ [ phpDrv ];

      patches = previousAttrs.patches or [ ];
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

          makeWrapper ${lib.getExe composer} $out/bin/composer \
            --prefix COMPOSER_HOME : ${finalAttrs.vendor}

            runHook postInstall
        '';

      doInstallCheck = previousAttrs.doInstallCheck or false;
      installCheckPhase =
        previousAttrs.installCheckPhase or ''
          runHook preInstallCheck

          composer global show ${finalAttrs.pname}

          runHook postInstallCheck
        '';

      vendor = previousAttrs.vendor or stdenvNoCC.mkDerivation {
        pname = "${finalAttrs.pname}-vendor";
        pluginName = finalAttrs.pname;

        inherit (finalAttrs) version src;

        composerLock = previousAttrs.composerLock or null;
        composerNoDev = previousAttrs.composerNoDev or true;
        composerNoPlugins = previousAttrs.composerNoPlugins or true;
        composerNoScripts = previousAttrs.composerNoScripts or true;
        composerStrictValidation = previousAttrs.composerStrictValidation or true;
        composerGlobal = true;
        composerJson = composerJsonBuilder finalAttrs.pname finalAttrs.version;

        nativeBuildInputs = [
          cacert
          composer
          phpDrv.composerHooks.composerWithPluginVendorHook
        ];

        dontPatchShebangs = true;
        doCheck = true;
        doInstallCheck = true;

        env = {
          COMPOSER_CACHE_DIR = "/dev/null";
          COMPOSER_HTACCESS_PROTECT = "0";
        };

        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = finalAttrs.vendorHash;
      };

      # Projects providing a lockfile from upstream can be automatically updated.
      passthru = previousAttrs.passthru or { } // {
        updateScript =
          previousAttrs.passthru.updateScript
            or (if finalAttrs.vendor.composerLock == null then nix-update-script { } else null);
      };

      meta = previousAttrs.meta or composer.meta;
    };
in
args: (stdenvNoCC.mkDerivation args).overrideAttrs buildComposerWithPluginOverride
