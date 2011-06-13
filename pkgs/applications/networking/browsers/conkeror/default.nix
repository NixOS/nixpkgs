{ stdenv, fetchurl, unzip }:
stdenv.mkDerivation {
  name = "conkeror-0.9.3-20110606";
  src = fetchurl {
    url = http://repo.or.cz/w/conkeror.git/snapshot/0d883dfd5e61e7d0b8a96a079d69b46af064fdca.zip;
    sha256 = "0h21fw78iq4hljy5p98mpy0wgd5wpx9a0jdwv7l5wrds5vp23dhh";
  };
  buildInputs = [ unzip ];
  installPhase = ''
    cp -v -r . $out
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
