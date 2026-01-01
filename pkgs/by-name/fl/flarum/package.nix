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
<<<<<<< HEAD
  vendorHash = "sha256-EHl+Mr6y5A51EpLPAWUGtiPkLOky6KvsSY4JWHeyO28=";

  meta = {
=======
  vendorHash = "sha256-4wB8MRnqnruo9VXupMmAqiRSZx8F2i+8zcOphTeDp1g=";

  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/flarum/framework/blob/main/CHANGELOG.md";
    description = "Delightfully simple discussion platform for your website";
    homepage = "https://github.com/flarum/flarum";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fsagbuya
      jasonodoom
    ];
  };
})
