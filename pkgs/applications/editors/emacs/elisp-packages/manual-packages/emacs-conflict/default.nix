{ lib
, fetchFromGitHub
, trivialBuild
, emacs
}:

trivialBuild {
  pname = "emacs-conflict";
  version = "0-unstable-2022-11-21";

  src = fetchFromGitHub {
    owner = "ibizaman";
    repo = "emacs-conflict";
    rev = "9f236b93930f3ceb4cb0258cf935c99599191de3";
    sha256 = "sha256-DIGvnotSQYIgHxGxtyCALHd8ZbrfkmdvjLXlkcqQ6v4=";
  };

  meta = with lib; {
    description = "Resolve conflicts happening when using file synchronization tools";
    homepage = "https://github.com/ibizaman/emacs-conflict";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ibizaman ];
    inherit (emacs.meta) platforms;
  };
}
