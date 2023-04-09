{ stdenvNoCC, lib, writeTextDir, php }:

let
  buildComposerProjectOverride = finalAttrs: previousAttrs:

  let
    phpDrv = finalAttrs.php or php;
    composer = finalAttrs.composer or phpDrv.packages.composer;
    composerLock = finalAttrs.composerLock or null;
  in {
    nativeBuildInputs = (previousAttrs.nativeBuildInputs or []) ++ [
      composer
      phpDrv.composerHooks.composerInstallHook
    ];

    buildInputs = (previousAttrs.buildInputs or []) ++ [
      phpDrv
    ];

    patches = previousAttrs.patches or [];

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

    installPhase = previousAttrs.installPhase or ''
      runHook preInstall

      runHook postInstall
    '';

    composerOverrides = let
        content = (previousAttrs.composerOverrides or {
          config = {
            autoloader-suffix = "nixPredictableAutoloaderSuffix";
            apcu-autoloader = false;
          };
        });
      in
        writeTextDir "/composer.override.json" (if ((builtins.typeOf content) == "path")
          then (builtins.readFile content)
          else (builtins.toJSON content));

    composerVendorCache = phpDrv.mkComposerVendorCache {
      inherit composer composerLock;
      inherit (finalAttrs) vendorHash src patches version composerOverrides pname;
    };

    meta = previousAttrs.meta // {
      platforms = lib.platforms.all;
    };
  };
in
  args: (stdenvNoCC.mkDerivation args).overrideAttrs buildComposerProjectOverride
