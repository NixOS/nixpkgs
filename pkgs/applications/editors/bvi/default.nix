args:
args.stdenv.mkDerivation {
  name = "bvi-1.3.2";

  src = args.fetchurl {
    url = http://prdownloads.sourceforge.net/bvi/bvi-1.3.2.src.tar.gz;
    sha256 = "110wxqnyianqamxq4y53drqqxb9vp4k2fcvic45qggvlqkqhlfgz";
  };

  buildInputs =(with args; [ncurses]);

  meta = { 
      description = "hex editor with vim style keybindings";
      homepage = http://bvi.sourceforge.net/download.html;
      license = "GPL2";
  };
}
