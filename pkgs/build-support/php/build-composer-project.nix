{ callPackage, stdenvNoCC, lib, writeTextDir, php, makeBinaryWrapper, fetchFromGitHub, fetchurl }:

let
  buildComposerProjectOverride = finalAttrs: previousAttrs:

    let
      phpDrv = finalAttrs.php or php;
      composer = finalAttrs.composer or phpDrv.packages.composer;
      composer-local-repo-plugin = callPackage ./pkgs/composer-local-repo-plugin.nix { };
    in
    {
      composerLock = previousAttrs.composerLock or null;
      composerNoDev = previousAttrs.composerNoDev or true;
      composerNoPlugins = previousAttrs.composerNoPlugins or true;
      composerNoScripts = previousAttrs.composerNoScripts or true;
      composerStrictValidation = previousAttrs.composerStrictValidation or true;

      nativeBuildInputs = (previousAttrs.nativeBuildInputs or [ ]) ++ [
        composer
        composer-local-repo-plugin
        phpDrv
        phpDrv.composerHooks.composerInstallHook
      ];

      buildInputs = (previousAttrs.buildInputs or [ ]) ++ [
        phpDrv
      ];

      patches = previousAttrs.patches or [ ];
      strictDeps = previousAttrs.strictDeps or true;

      # Should we keep these empty phases?
      configurePhase = previousAttrs.configurePhase or ''
        runHook preConfigure

        runHook postConfigure
      '';

      buildPhase = previousAttrs.buildPhase or ''
        runHook preBuild

        runHook postBuild
      '';

      doCheck = previousAttrs.doCheck or true;
      checkPhase = previousAttrs.checkPhase or ''
        runHook preCheck

        runHook postCheck
      '';

      installPhase = previousAttrs.installPhase or ''
        runHook preInstall

        runHook postInstall
      '';

      doInstallCheck = previousAttrs.doInstallCheck or false;
      installCheckPhase = previousAttrs.installCheckPhase or ''
        runHook preCheckInstall

        runHook postCheckInstall
      '';

      composerRepository = phpDrv.mkComposerRepository {
        inherit composer composer-local-repo-plugin;
        inherit (finalAttrs) patches pname src vendorHash version;

        composerLock = previousAttrs.composerLock or null;
        composerNoDev = previousAttrs.composerNoDev or true;
        composerNoPlugins = previousAttrs.composerNoPlugins or true;
        composerNoScripts = previousAttrs.composerNoScripts or true;
        composerStrictValidation = previousAttrs.composerStrictValidation or true;
      };

      COMPOSER_CACHE_DIR="/dev/null";
      COMPOSER_DISABLE_NETWORK="1";
      COMPOSER_MIRROR_PATH_REPOS="1";

      meta = previousAttrs.meta or { } // {
        platforms = lib.platforms.all;
      };
    };
in
args: (stdenvNoCC.mkDerivation args).overrideAttrs buildComposerProjectOverride
