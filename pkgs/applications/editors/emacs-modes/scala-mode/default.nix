{ fetchsvn, stdenv, emacs }:

let revision = "17339"; in
stdenv.mkDerivation rec {
  name = "scala-mode-r${revision}";

  src = fetchsvn {
    url = "http://lampsvn.epfl.ch/svn-repos/scala/scala-tool-support/trunk/src/emacs";
    rev = revision;
    sha256 = "05g3xk2mxkqwdnyvxklnrdyhppkvhfs2fd21blhzbhf474cgqlyh";
  };

  buildInputs = [ emacs ];

  installPhase =
    '' ensureDir "$out/share/emacs/site-lisp"
       cp -v *.el *.elc "$out/share/emacs/site-lisp"
    '';

  meta = {
    description = "An Emacs mode for editing Scala code";

    homepage = http://www.scala-lang.org/node/354;

    # non-copyleft, BSD-style
    license = "permissive";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
