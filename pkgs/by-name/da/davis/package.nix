{ lib, fetchFromGitHub, php, }:

php.buildComposerProject (finalAttrs: {
  pname = "davis";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UBekmxKs4dveHh866Ix8UzY2NL6ygb8CKor+V3Cblns=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-WGeNwBRzfUXa7kPIwd7/5dPXDjaBxXirAJcm6lNzueY=";

  patches = [
    # Symfony loads .env files from the same directory as composer.json
    # The .env files contain runtime configuration that shouldn't be baked into deriviation for the package
    # This patch adds a few extension points exposing three environment variables:
    #    RUNTIME_DIRECTORY (where to load .env from), CACHE_DIRECTORY and LOG_DIRECTORY (symfony cache and log rw directories)
    # Upstream PR https://github.com/tchapi/davis/issues/154
    ./davis-data.patch
  ];

  postInstall = ''
    # Only include the files needed for runtime in the derivation
    mv $out/share/php/${finalAttrs.pname}/{migrations,public,src,config,bin,templates,tests,translations,vendor,symfony.lock,composer.json,composer.lock} $out
    # Save the upstream .env file for reference, but rename it so it is not loaded
    mv $out/share/php/${finalAttrs.pname}/.env $out/env-upstream
    rm -rf "$out/share"
  '';

  meta = {
    changelog = "https://github.com/tchapi/davis/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/tchapi/davis";
    description = "A simple CardDav and CalDav server inspired by Baïkal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ramblurr ];
  };
})
