{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "davis";
  version = "4.4.3";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0Km4bLQVfbkr5BL8XY5tM147Sje8hcFOjhCRnXq+4d4=";
  };

  vendorHash = "sha256-NOb6rc9jVsf+/RVOW7SLBAJk9SihcRxoepUEGBGLi2w=";

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
