{ stdenv, fetchurl, emacs, unzip }:

stdenv.mkDerivation {

  name = "scala-mode2-2014-07-01";

  src = fetchurl {
    url = "https://github.com/hvesalai/scala-mode2/archive/c154f1623f4696d26e1c88d19170e67bf6825837.zip";
    sha256 = "0im2ajb1iagjldh52j8wz4yby68rs3h7shrdf1pqy5ds7s4fa8cc";
  };

  buildInputs = [ unzip emacs ];

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp -v *.el *.elc "$out/share/emacs/site-lisp/"
  '';

  meta = {
    homepage = https://github.com/hvesalai/scala-mode2;
    description = "An Emacs mode for editing Scala code";
    license = "permissive";
  };
}
