{
  lib,
  php,
  fetchFromGitHub,
}:

php.buildComposerProject (finalAttrs: {
  pname = "flarum";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "flarum";
    repo = "flarum";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kigUZpiHTM24XSz33VQYdeulG1YI5s/M02V7xue72VM=";
  };

  composerLock = ./composer.lock;
  composerStrictValidation = false;
  vendorHash = "sha256-gQkjuatItw93JhI7FVfg5hYxkC1gsRQ3c2C2+MhI/Jg=";

  meta = with lib; {
    changelog = "https://github.com/flarum/framework/blob/main/CHANGELOG.md";
    description = "Flarum is a delightfully simple discussion platform for your website";
    homepage = "https://github.com/flarum/flarum";
    license = lib.licenses.mit;
    maintainers = with maintainers; [
      fsagbuya
      jasonodoom
    ];
  };
})
