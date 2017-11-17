{ fetchurl, lib, stdenv, melpaBuild }:

melpaBuild {
  pname = "filesets-plus";
  version = "20170222.55";

  src = fetchurl {
    url = "https://www.emacswiki.org/emacs/download/filesets%2b.el";
    sha256 = "0iajkgh0n3pbrwwxx9rmrrwz8dw2m7jsp4mggnhq7zsb20ighs00";
    name = "filesets+.el";
  };

  recipeFile = fetchurl {
    url = "https://raw.githubusercontent.com/milkypostman/melpa/a5d15f875b0080b12ce45cf696c581f6bbf061ba/recipes/filesets-plus+";
    sha256 = "1wn99cb53ykds87lg9mrlfpalrmjj177nwskrnp9wglyqs65lk4g";
    name = "filesets-plus";
  };

  meta = {
    homepage = "https://melpa.org/#/filesets+";
  };
}
