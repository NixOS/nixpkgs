{ fetchurl, stdenv, melpaBuild }:

melpaBuild {
  pname = "font-lock-plus";
  version = "20170222.1755";

  src = fetchurl {
    url = "https://www.emacswiki.org/emacs/download/font-lock+.el";
    sha256 = "0iajkgh0n3pbrwwxx9rmrrwz8dw2m7jsp4mggnhq7zsb20ighs30";
    name = "font-lock+.el";
  };

  recipeFile = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/a5d15f875b0080b12ce45cf696c581f6bbf061ba/recipes/font-lock+";
    sha256 = "1wn99cb53ykds87lg9mrlfpalrmjj177nwskrnp9wglyqs65lk4g";
    name = "font-lock-plus";
  };

  meta = with stdenv.lib; {
    homepage = "https://melpa.org/#/font-lock+";
    license = lib.licenses.gpl2Plus;
  };
}
