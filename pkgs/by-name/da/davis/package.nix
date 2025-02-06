{
  lib,
  fetchFromGitHub,
  php,
  nixosTests,
}:

php.buildComposerProject (finalAttrs: {
  pname = "davis";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zl+6nrgspyg6P9gqYwah81Z6Mtni6nUlCp4gTjJWn9M=";
  };

  vendorHash = "sha256-ZV5GNNtex+yKaMP5KaQkx5EaJRAJSwJjIZOCcXlnVW4=";

  postInstall = ''
    # Only include the files needed for runtime in the derivation
    mv $out/share/php/${finalAttrs.pname}/{migrations,public,src,config,bin,templates,tests,translations,vendor,symfony.lock,composer.json,composer.lock} $out
    # Save the upstream .env file for reference, but rename it so it is not loaded
    mv $out/share/php/${finalAttrs.pname}/.env $out/env-upstream
    rm -rf "$out/share"
  '';

  passthru.tests = {
    inherit (nixosTests) davis;
  };

  meta = {
    changelog = "https://github.com/tchapi/davis/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/tchapi/davis";
    description = "Simple CardDav and CalDav server inspired by Baïkal";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ramblurr ];
  };
})
