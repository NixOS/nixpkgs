{ fetchurl, lib, melpaBuild }:

melpaBuild {
  pname = "header2";
  version = "20170223.1949";

  src = fetchurl {
    url = "https://www.emacswiki.org/emacs/download/header2.el";
    sha256 = "0cv74cfihr13jrgyqbj4x0na659djfyrhflxni6jdbgbysi4zf6k";
    name = "header2.el";
  };

  recipe = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/a5d15f875b0080b12ce45cf696c581f6bbf061ba/recipes/header2";
    sha256 = "1dg25krx3wxma2l5vb2ji7rpfp17qbrl62jyjpa52cjfsvyp6v06";
    name = "header2";
  };

  meta = {
    homepage = "https://melpa.org/#/header2";
    license = lib.licenses.gpl3;
  };
}
