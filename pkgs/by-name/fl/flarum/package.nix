{
  lib,
  php,
  fetchFromGitHub,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "flarum";
  version = "1.8.19";

  src = fetchFromGitHub {
    owner = "flarum";
    repo = "flarum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zi7JVL4JHwYXsJLT8r2FYRNUUomVduxWinfRnQzYU4M=";
  };

  # Lock regenerated in a checkout of src with (flysystem 1.x has an unfixable advisory):
  # COMPOSER_NO_SECURITY_BLOCKING=1 nix-shell -p phpPackages.composer --run "composer update --no-install"
  composerLock = ./composer.lock;
  vendorHash = "sha256-EXKQ9x7E15Fc4fu/XdjlgMDCpmvg1XupBGq13WDspDI=";

  passthru.tests.module = nixosTests.flarum;

  meta = {
    changelog = "https://github.com/flarum/framework/blob/main/CHANGELOG.md";
    description = "Delightfully simple discussion platform for your website";
    homepage = "https://github.com/flarum/flarum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fsagbuya
      jasonodoom
    ];
  };
})
