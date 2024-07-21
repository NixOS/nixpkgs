{
  lib,
  melpaBuild,
  fetchFromGitHub,
}:

melpaBuild rec {
  pname = "rect-mark";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "rect-mark";
    rev = version;
    hash = "sha256-/8T1VTYkKUxlNWXuuS54S5jpl4UxJBbgSuWc17a/VyM=";
  };

  meta = {
    homepage = "http://emacswiki.org/emacs/RectangleMark";
    description = "Mark a rectangle of text with highlighting";
    license = lib.licenses.gpl2Plus;
  };
}
