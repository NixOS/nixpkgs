{ lib
, fetchFromGitHub
, melpaBuild
, writeMelpaRecipe
}:

let
  pname = "git-undo";
  version = "20231224.2002";

  src = fetchFromGitHub {
    owner = "jwiegley";
    repo = "git-undo-el";
    rev = "3d9c95fc40a362eae4b88e20ee21212d234a9ee6";
    hash = "sha256-cVkK9EF6qQyVV3uVqnBEjF8e9nEx/8ixnM8PvxqCyYE=";
  };
in
melpaBuild {
  inherit pname version src;

  recipe = writeMelpaRecipe {
    package-name = "git-undo";
    fetcher = "github";
    repo = "jwiegley/git-undo-el";
  };

  commit = src.rev;

  meta = {
    homepage = "https://github.com/jwiegley/git-undo-el";
    description = "Revert region to most recent Git-historical version";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ leungbk ];
  };
}
