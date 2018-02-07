{ fetchurl, lib, stdenv, melpaBuild }:

melpaBuild {
  pname = "hexrgb";
  version = "20170304.1017";

  src = fetchurl {
    url = "https://www.emacswiki.org/emacs/download/hexrgb.el";
    sha256 = "1aj1fsc3wr8174xs45j2wc2mm6f8v6zs40xn0r4qisdw0plmsbsy";
    name = "hexrgb.el";
  };

  recipeFile = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/a5d15f875b0080b12ce45cf696c581f6bbf061ba/recipes/hexrgb";
    sha256 = "0mzqslrrf7sc262syj3ja7b7rnbg80dwf2p9bzxdrzx6b8vvsx06";
    name = "hexrgb";
  };

  meta = {
    homepage = "https://melpa.org/#/hexrgb";
    license = lib.licenses.gpl2Plus;
  };
}
