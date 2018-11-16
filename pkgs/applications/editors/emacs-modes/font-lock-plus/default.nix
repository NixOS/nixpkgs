{ fetchurl, lib, melpaBuild }:

melpaBuild {
  pname = "font-lock-plus";
  version = "20180101.25";

  src = fetchurl {
    url = "https://www.emacswiki.org/emacs/download/font-lock%2b.el?revision=25";
    sha256 = "0197yzn4hbjmw5h3m08264b7zymw63pdafph5f3yzfm50q8p7kp4";
    name = "font-lock+.el";
  };

  recipe = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/a5d15f875b0080b12ce45cf696c581f6bbf061ba/recipes/font-lock+";
    sha256 = "1wn99cb53ykds87lg9mrlfpalrmjj177nwskrnp9wglyqs65lk4g";
    name = "font-lock-plus";
  };

  meta = {
    homepage = "https://melpa.org/#/font-lock+";
    license = lib.licenses.gpl2Plus;
  };
}
