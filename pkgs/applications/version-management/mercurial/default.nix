{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation {
  name = "mercurial-0.9.4";
  src = fetchurl {
    url = http://www.selenic.com/mercurial/release/mercurial-0.9.4.tar.gz;
    sha256 = "26996df67d508e129d2f0a264e25072764e5c2d21606e1658d77c8984e6ed64a";
  };

  inherit makeWrapper;

  buildInputs = [ python ];
  addInputsHook = "source $makeWrapper";
  makeFlags = "PREFIX=$(out)";
  postInstall = [
    "for i in $(cd $out/bin && ls); do"
    "   mv $out/bin/$i $out/bin/.orig-$i;"
    "   makeWrapper $out/bin/.orig-$i $out/bin/$i"
    "       --set PYTHONPATH \"$(toPythonPath $out):$PYTHONPATH\";"
    "done"
  ];

  meta = {
    description = "a fast, lightweight SCM system for very large distributed projects";
  };
}
