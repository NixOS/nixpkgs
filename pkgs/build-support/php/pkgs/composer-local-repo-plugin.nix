{ callPackage, stdenvNoCC, lib, fetchFromGitHub, makeBinaryWrapper }:

let
  composer = callPackage ./composer-phar.nix { };

  composerKeys = stdenvNoCC.mkDerivation (finalComposerKeysAttrs: {
    pname = "composer-keys";
    version = "fa5a62092f33e094073fbda23bbfc7188df3cbc5";

    src = fetchFromGitHub {
      owner = "composer";
      repo = "composer.github.io";
      rev = "${finalComposerKeysAttrs.version}";
      hash = "sha256-3Sfn71LDG1jHwuEIU8iEnV3k6D6QTX7KVIKVaNSuCVE=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      install releases.pub $out/keys.tags.pub
      install snapshots.pub $out/keys.dev.pub

      runHook postInstall
    '';
  });
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "composer-local-repo-plugin";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "composer-local-repo-plugin";
    rev = finalAttrs.version;
    hash = "sha256-L1DPAINlYiC/HdcgDpI72OI58v8LWfhZVuS1vtNDnEw=";
  };

  COMPOSER_CACHE_DIR = "/dev/null";
  COMPOSER_MIRROR_PATH_REPOS = "1";
  COMPOSER_HTACCESS_PROTECT = "0";
  COMPOSER_DISABLE_NETWORK = "1";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  buildInputs = [
    composer
  ];

  configurePhase = ''
    runHook preConfigure

    export COMPOSER_HOME=${placeholder "out"}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Configure composer globally
    composer global init --quiet --no-interaction --no-ansi \
      --name="nixos/composer" \
      --homepage "https://nixos.org/" \
      --description "Composer with nix-community/composer-local-repo-plugin" \
      --license "MIT"

    composer global config --quiet minimum-stability dev
    composer global config --quiet prefer-stable true
    composer global config --quiet autoloader-suffix "nixPredictableAutoloaderSuffix"
    composer global config --quiet apcu-autoloader false
    composer global config --quiet allow-plugins.nix-community/composer-local-repo-plugin true
    composer global config --quiet repo.packagist false
    composer global config --quiet repo.plugin path $src

    # Install the local repository plugin
    composer global require --quiet --no-ansi --no-interaction nix-community/composer-local-repo-plugin

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    composer global validate --no-ansi
    composer global show --no-ansi nix-community/composer-local-repo-plugin

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -ar ${composerKeys}/* $out/

    makeWrapper ${composer}/bin/composer $out/bin/composer-local-repo-plugin \
      --prefix COMPOSER_HOME : $out

    runHook postInstall
  '';

  meta = {
    description = "Composer local repo plugin for Composer";
    homepage = "https://github.com/nix-community/composer-local-repo-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
