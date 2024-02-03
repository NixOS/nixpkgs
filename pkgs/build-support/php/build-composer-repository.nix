{ callPackage, stdenvNoCC, lib, writeTextDir, fetchFromGitHub, php }:

let
  mkComposerRepositoryOverride =
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
      composer-local-repo-plugin = callPackage ./pkgs/composer-local-repo-plugin.nix { };
    in
    assert (lib.assertMsg (previousAttrs ? src) "mkComposerRepository expects src argument.");
    assert (lib.assertMsg (previousAttrs ? vendorHash) "mkComposerRepository expects vendorHash argument.");
    assert (lib.assertMsg (previousAttrs ? version) "mkComposerRepository expects version argument.");
    assert (lib.assertMsg (previousAttrs ? pname) "mkComposerRepository expects pname argument.");
    assert (lib.assertMsg (previousAttrs ? composerNoDev) "mkComposerRepository expects composerNoDev argument.");
    assert (lib.assertMsg (previousAttrs ? composerNoPlugins) "mkComposerRepository expects composerNoPlugins argument.");
    assert (lib.assertMsg (previousAttrs ? composerNoScripts) "mkComposerRepository expects composerNoScripts argument.");
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
        composer-local-repo-plugin
        phpDrv
        phpDrv.composerHooks.composerRepositoryHook
      ];

      buildInputs = previousAttrs.buildInputs or [ ];

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

      COMPOSER_CACHE_DIR = "/dev/null";
      COMPOSER_MIRROR_PATH_REPOS = "1";
      COMPOSER_HTACCESS_PROTECT = "0";
      COMPOSER_DISABLE_NETWORK = "0";

      outputHashMode = "recursive";
      outputHashAlgo = if (finalAttrs ? vendorHash && finalAttrs.vendorHash != "") then null else "sha256";
      outputHash = finalAttrs.vendorHash or "";
    };
in
args: (stdenvNoCC.mkDerivation args).overrideAttrs mkComposerRepositoryOverride
