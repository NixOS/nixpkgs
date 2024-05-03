{ callPackage, stdenvNoCC, lib, writeTextDir, php, makeBinaryWrapper, fetchFromGitHub, fetchurl }:

let
  initialArgs = {
    inherit php;
  };
  buildComposerProjectOverride = finalAttrs: previousAttrs:

    let
      composer = finalAttrs.composer or finalAttrs.php.composer;
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
        finalAttrs.php
        finalAttrs.php.composerHooks.composerInstallHook
      ];

      buildInputs = (previousAttrs.buildInputs or [ ]) ++ [
        finalAttrs.php
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
        runHook preInstallCheck

        runHook postInstallCheck
      '';

      composerRepository = finalAttrs.php.mkComposerRepository {
        inherit composer composer-local-repo-plugin;
        inherit (finalAttrs) patches pname src vendorHash version;

        php = finalAttrs.php;
        composerLock = previousAttrs.composerLock or null;
        composerNoDev = previousAttrs.composerNoDev or true;
        composerNoPlugins = previousAttrs.composerNoPlugins or true;
        composerNoScripts = previousAttrs.composerNoScripts or true;
        composerStrictValidation = previousAttrs.composerStrictValidation or true;
      };

      env = {
        COMPOSER_CACHE_DIR = "/dev/null";
        COMPOSER_DISABLE_NETWORK = "1";
        COMPOSER_MIRROR_PATH_REPOS = "1";
      };

      meta = previousAttrs.meta or { } // {
        platforms = lib.platforms.all;
      };
    };
in
args: (stdenvNoCC.mkDerivation (initialArgs // args)).overrideAttrs buildComposerProjectOverride
