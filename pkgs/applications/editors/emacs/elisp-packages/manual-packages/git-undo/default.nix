{ lib
, fetchFromGitHub
, emacs
, trivialBuild
}:

trivialBuild {
  pname = "git-undo";
  version = "0-unstable-2019-12-21";

  src = fetchFromGitHub {
    owner = "jwiegley";
    repo = "git-undo-el";
    rev = "cf31e38e7889e6ade7d2d2b9f8719fd44f52feb5";
    sha256 = "sha256-cVkK9EF6qQyVV3uVqnBEjF8e9nEx/8ixnM8PvxqCyYE=";
  };

  meta = with lib; {
    homepage = "https://github.com/jwiegley/git-undo-el";
    description = "Revert region to most recent Git-historical version";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leungbk ];
    inherit (emacs.meta) platforms;
  };
}
