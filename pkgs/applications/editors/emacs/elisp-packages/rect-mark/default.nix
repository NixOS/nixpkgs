{ lib
, trivialBuild
, fetchFromGitHub
, emacs
 }:

trivialBuild rec {
  pname = "rect-mark";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = pname;
    rev = version;
    hash = "sha256-/8T1VTYkKUxlNWXuuS54S5jpl4UxJBbgSuWc17a/VyM=";
  };

  buildInputs = [ emacs ];

  meta = with lib; {
    homepage = "http://emacswiki.org/emacs/RectangleMark";
    description = "Mark a rectangle of text with highlighting";
    license = licenses.gpl2Plus;
    inherit (emacs.meta) platforms;
  };
}
