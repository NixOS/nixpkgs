args: with args;

stdenv.mkDerivation {
  name = "mercurial-0.9.5";
  src = fetchurl {
    url = http://www.selenic.com/mercurial/release/mercurial-0.9.5.tar.gz;
    sha256 = "1n34yl4z7nc3vmsgpkmqc94hsmy846ny86xgpgv3m371ljm2pq6g";
  };

  inherit makeWrapper;

  buildInputs = [ python ];
  addInputsHook = "source $makeWrapper";
  makeFlags = "PREFIX=$(out)";
  postInstall = [
    "for i in $(cd $out/bin && ls); do"
    "   mv $out/bin/$i $out/bin/.orig-$i;"
    "   makeWrapper $out/bin/.orig-$i $out/bin/$i"
    "       --set PYTHONPATH \"$(toPythonPath $out):$PYTHONPATH:\$PYTHONPATH\";"
    "done"
  ];

  meta = {
    description = "a fast, lightweight SCM system for very large distributed projects";
  };
}
