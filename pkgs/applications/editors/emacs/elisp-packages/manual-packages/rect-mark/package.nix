{
  lib,
  melpaBuild,
  fetchFromGitHub,
}:

let
  version = "1.4";
in
melpaBuild {
  pname = "rect-mark";
  inherit version;

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "rect-mark";
    tag = version;
    hash = "sha256-/8T1VTYkKUxlNWXuuS54S5jpl4UxJBbgSuWc17a/VyM=";
  };

  meta = {
    homepage = "http://emacswiki.org/emacs/RectangleMark";
    description = "Mark a rectangle of text with highlighting";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}
