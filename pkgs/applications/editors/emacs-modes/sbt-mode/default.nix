{ stdenv, fetchurl, emacs, unzip }:

stdenv.mkDerivation {

  name = "sbt-mode-2014-06-05";

  src = fetchurl {
    url = "https://github.com/hvesalai/sbt-mode/archive/676f22d9658989de401d299ed0250db9b911574d.zip";
    sha256 = "0b8qrr3yp48ggl757d3a6bz633mbf4zxqpcwsh47b1ckiwa3nb2h";
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
