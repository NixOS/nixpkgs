{ lib
, fetchFromGitHub
, melpaBuild
, writeText
}:

let
  pname = "yes-no";
  ename = "yes-no";
  version = "20240107.122";
  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "emacswiki.org";
    rev = "02dbe9aa48c735cfcc7e977ea8fe512328666cad";
    hash = "sha256-J7JbAUwlf0dQlKx613bdmwRNI0qs7INJuj7FEm5uvBU=";
  };
in
melpaBuild {
  inherit pname ename version src;

  commit = src.rev;

  recipe = writeText "recipe" ''
    (yes-no
     :repo "emacsmirror/emacswiki.org"
     :fetcher github
     :files ("yes-no.el"))
  '';

  meta = {
    description = "Specify use of `y-or-n-p' or `yes-or-no-p' on a case-by-case basis";
    homepage = "https://www.emacswiki.org/emacs/yes-no.el";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jcs090218 ];
  };
}
