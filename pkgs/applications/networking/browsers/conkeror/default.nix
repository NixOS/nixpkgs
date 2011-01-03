{ stdenv, fetchurl, unzip }:
stdenv.mkDerivation {
  name = "conkeror-0.9.3";
  src = fetchurl {
    url = http://repo.or.cz/w/conkeror.git/snapshot/e5fda614a5debf51ad348291f1001d6f6a8a5fb5.zip;
    sha256 = "1figrvyk0fhjvwrijkl0kc2gca5h1l7bdh9vyvkhkp9p77r5hykq";
  };
  buildInputs = [ unzip ];
  installPhase = ''
    cp -r . $out
  '';
  meta = {
    description = "A keyboard-oriented, customizable, extensible web browser";
    longDescription = ''
      Conkeror is a keyboard-oriented, highly-customizable, highly-extensible
      web browser based on Mozilla XULRunner, written mainly in JavaScript,
      and inspired by exceptional software such as Emacs and vi. Conkeror
      features a sophisticated keyboard system, allowing users to run commands
      and interact with content in powerful and novel ways. It is
      self-documenting, featuring a powerful interactive help system.
    '';
    homepage = http://conkeror.org/;
    license = [ "MPLv1.1" "GPLv2" "LGPLv2.1" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
