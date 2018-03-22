{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "stgit";
  name = "${pname}-2009-10-28";

  unpackPhase = "true";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/miracle2k/stgit/master/contrib/stgit.el";
    sha256 = "0pl8q480633vdkylr85s7cbd4653xpzwklnxrwm8xhsnvw9d501q";
    name = "stgit.el";
  };

  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    cp $src $out/share/emacs/site-lisp/stgit.el
  '';

  meta = {
    description = "An emacs mode for Stgit";
    homepage = http://procode.org/stgit/;
    platforms = stdenv.lib.platforms.all;
  };
}
