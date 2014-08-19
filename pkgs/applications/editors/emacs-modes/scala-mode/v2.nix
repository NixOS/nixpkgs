{ stdenv, fetchurl, emacs, unzip }:

stdenv.mkDerivation {

  name = "scala-mode2-2014-06-05";

  src = fetchurl {
    url = "https://github.com/hvesalai/scala-mode2/archive/af2dc30226c890ff7d49d727450f8006b90781df.zip";
    sha256 = "1jj08li9lfg5291jzj170wa3cmyf3g2a0j80cy5307l0mdawp9vx";
  };

  buildInputs = [ unzip emacs ];

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp -v *.el *.elc "$out/share/emacs/site-lisp/"
  '';

  meta = {
    homepage = "https://github.com/hvesalai/scala-mode2";
    description = "An Emacs mode for editing Scala code";
    license = "permissive";
  };
}
