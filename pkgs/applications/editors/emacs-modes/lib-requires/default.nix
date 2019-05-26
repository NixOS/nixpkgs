{ fetchurl, lib, melpaBuild }:

melpaBuild {
  pname = "lib-requires";
  version = "20170307.757";

  src = fetchurl {
    url = "https://www.emacswiki.org/emacs/download/lib-requires.el";
    sha256 = "04lrkdjrhsgg7vgvw1mkr9a5m9xlyvjvnj2aj6w453bgmnp1mbvv";
    name = "lib-requires.el";
  };

  recipe = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/a5d15f875b0080b12ce45cf696c581f6bbf061ba/recipes/lib-requires";
    sha256 = "1g22jh56z8rnq0h80wj10gs38yig1rk9xmk3kmhmm5mm6b14iwdx";
    name = "lib-requires";
  };

  meta = {
    homepage = "https://melpa.org/#/lib-requires";
    license = lib.licenses.gpl2Plus;
  };
}
