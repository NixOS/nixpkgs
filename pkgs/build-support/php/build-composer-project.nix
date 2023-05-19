{ stdenvNoCC, lib, writeTextDir, php, makeBinaryWrapper, fetchFromGitHub, fetchurl }:

let
  buildComposerProjectOverride = finalAttrs: previousAttrs:

  let
    phpDrv = finalAttrs.php or php;
    composer = finalAttrs.composer or phpDrv.packages.composer;
    composerLock = finalAttrs.composerLock or null;
    composerHomeDir = finalAttrs.composerHomeDir or null;
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

    doCheck = previousAttrs.doCheck or true;
    checkPhase = previousAttrs.checkPhase or ''
      runHook preCheck

      runHook postCheck
    '';

    installPhase = previousAttrs.installPhase or ''
      runHook preInstall

      runHook postInstall
    '';

    composerKeys = stdenvNoCC.mkDerivation (finalComposerKeysAttrs: {
        pname = "composer-keys";
        version = "1.0.0";

        srcs = [
          (fetchurl {
            name = "keys.dev.pub";
            hash = "sha256-Ky34n7JYHmabRmi0UQl9SgP03C16Bt8ZdVQGRJSpCjE=";
            url = "https://composer.github.io/snapshots.pub";
          })
          (fetchurl {
            name = "keys.tags.pub";
            hash = "sha256-2PPjUEN787U0Lb8EYGTr0fAX68cglVQzGUNgoBz9B08=";
            url = "https://composer.github.io/releases.pub";
          })
        ];

        unpackPhase = ''
          runHook preUnpack

          for _src in $srcs; do
            cp "$_src" $(stripHash "$_src")
          done

          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out
          cp *.pub $out/

          runHook postInstall
        '';
      });

    composerHomeDir = stdenvNoCC.mkDerivation (finalComposerHomeAttrs: {
      pname = "composer-home-dir-with-repo-plugin";
      version = "9e1144ba0f3e98442bbfc955edd148be281c4148";

      src = fetchFromGitHub {
        owner = "drupol";
        repo = "composer-local-repo-plugin";
        rev = finalComposerHomeAttrs.version;
        hash = "sha256-puhzLweuoJ2vynToZI7rVO1eWNt2cWWCKeP+uQjGTY4=";
      };

      doCheck = true;
      dontUnpack = true;

      COMPOSER_HOME="/build";
      COMPOSER_CACHE_DIR="/dev/null";
      COMPOSER_MIRROR_PATH_REPOS="1";
      COMPOSER_HTACCESS_PROTECT="0";

      nativeBuildInputs = [
        composer
      ];

      configurePhase = ''
        cp -ar ${finalAttrs.composerKeys}/* $COMPOSER_HOME/

        composer --no-ansi --version
        composer diagnose
      '';

      buildPhase = ''
        runHook preBuild

        # Configure composer globally
        composer global init --quiet --no-interaction --no-ansi \
          --name="nixos/composer" \
          --homepage "https://nixos.org/" \
          --description "Composer home directory with drupol/composer-local-repo-plugin" \
          --license "MIT"

        composer global config --quiet minimum-stability dev
        composer global config --quiet prefer-stable true
        composer global config --quiet autoloader-suffix "nixPredictableAutoloaderSuffix"
        composer global config --quiet apcu-autoloader false
        composer global config --quiet allow-plugins.drupol/composer-local-repo-plugin true
        composer global config --quiet repo.plugin '{"type": "path", "url": "/build"}'
        composer global --no-ansi validate

        # Install the local repository plugin
        composer global require --quiet --no-ansi --no-interaction drupol/composer-local-repo-plugin

        composer global config --quiet --no-ansi --unset repositories

        runHook postBuild
      '';

      checkPhase = ''
        # Test if the plugin is installed correctly
        composer global show --no-ansi drupol/composer-local-repo-plugin
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -ar composer.json composer.lock vendor $out/
        cp -ar ${finalAttrs.composerKeys}/* $out/

        runHook postInstall
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-fCZGhsi/j+C7q9zna6M09Pbfcydc7iqM5QWEI4nh/8Q=";
    });

    COMPOSER_CACHE_DIR="/dev/null";
    COMPOSER_PROCESS_TIMEOUT="0";
    COMPOSER_HTACCESS_PROTECT="0";
    COMPOSER_DISABLE_NETWORK="1";
    COMPOSER_HOME="${finalAttrs.composerHomeDir}";
    COMPOSER_MIRROR_PATH_REPOS="1";

    composerRepository = phpDrv.mkComposerRepository {
      inherit composer composerLock;
      inherit (finalAttrs) composerHomeDir patches pname src vendorHash version;
    };

    meta = previousAttrs.meta or {} // {
      platforms = lib.platforms.all;
    };
  };
in
  args: (stdenvNoCC.mkDerivation args).overrideAttrs buildComposerProjectOverride
