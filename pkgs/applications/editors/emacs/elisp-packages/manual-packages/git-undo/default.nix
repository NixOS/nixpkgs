{
  lib,
  fetchFromGitHub,
  melpaBuild,
}:

melpaBuild {
  pname = "git-undo";
  version = "0-unstable-2019-12-21";

  src = fetchFromGitHub {
    owner = "jwiegley";
    repo = "git-undo-el";
    rev = "cf31e38e7889e6ade7d2d2b9f8719fd44f52feb5";
    hash = "sha256-cVkK9EF6qQyVV3uVqnBEjF8e9nEx/8ixnM8PvxqCyYE=";
  };

  meta = {
    homepage = "https://github.com/jwiegley/git-undo-el";
    description = "Revert region to most recent Git-historical version";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ leungbk ];
  };
}
