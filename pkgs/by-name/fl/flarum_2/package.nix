{
  lib,
  php,
  fetchFromGitHub,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  __structuredAttrs = true;

  pname = "flarum";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "flarum";
    repo = "flarum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OBmuYhHWinZe6g9iHLTY6iCOBrDraBctS6biE6VZ8IM=";
  };

  # Upstream doesn't ship a lock file. To regenerate, in a checkout of src:
  # nix-shell -p php84 php84Packages.composer --run "composer update --no-install"
  composerLock = ./composer.lock;
  vendorHash = "sha256-XYh71v4ZB1u1aAgoxzDVCEopB51xJxW5KihL34JoPgw=";

  passthru.tests.module = nixosTests.flarum_2;

  meta = {
    changelog = "https://github.com/flarum/framework/blob/2.x/CHANGELOG.md";
    description = "Delightfully simple discussion platform for your website";
    homepage = "https://github.com/flarum/flarum";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fsagbuya
      jasonodoom
    ];
  };
})
