{
  lib,
  php,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Add useful extensions from https://github.com/FriendsOfFlarum
    # Extensions included: fof/upload, fof/polls, fof/subscribed
    ./fof-extensions.patch
  ];

  composerLock = ./composer.lock;
  composerStrictValidation = false;
  vendorHash = "sha256-z3KVGmILw8MZ4aaSf6IP/0l16LI/Y2yMzY2KMHf4qSg=";

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
