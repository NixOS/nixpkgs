{ fetchurl, lib, stdenv, melpaBuild }:

melpaBuild {
  pname = "thingatpt-plus";
  version = "20170307.1539";

  src = fetchurl {
    url = "https://www.emacswiki.org/emacs/download/thingatpt+.el";
    sha256 = "1k9y354315gvhbdk0m9xpjx24w1bwrnzlnfiils8xgdwnw4py99a";
    name = "thingatpt+.el";
  };

  recipeFile = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/a5d15f875b0080b12ce45cf696c581f6bbf061ba/recipes/thingatpt+";
    sha256 = "0w031lzjl5phvzsmbbxn2fpziwkmdyxsn08h6b9lxbss1prhx7aa";
    name = "thingatpt-plus";
  };

  meta = {
    homepage = "https://melpa.org/#/thingatpt+";
    license = lib.licenses.gpl2Plus;
  };
}
