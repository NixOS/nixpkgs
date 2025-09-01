{
  lib,
  php,
  fetchFromGitHub,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "flarum";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "flarum";
    repo = "flarum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kigUZpiHTM24XSz33VQYdeulG1YI5s/M02V7xue72VM=";
  };

  composerLock = ./composer.lock;
  composerStrictValidation = false;
  vendorHash = "sha256-pup+ZfPEnqoA3wEXQNn4pWTYXri6d4XzMfuc8k1SeQk=";

  meta = with lib; {
    changelog = "https://github.com/flarum/framework/blob/main/CHANGELOG.md";
    description = "Delightfully simple discussion platform for your website";
    homepage = "https://github.com/flarum/flarum";
    license = lib.licenses.mit;
    maintainers = with maintainers; [
      fsagbuya
      jasonodoom
    ];
  };
})
