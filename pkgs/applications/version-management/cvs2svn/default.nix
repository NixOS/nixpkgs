{stdenv, fetchurl, python, bsddb3, makeWrapper}:

stdenv.mkDerivation {
  name = "cvs2svn-1.5.1";

  src = fetchurl {
    url = http://cvs2svn.tigris.org/files/documents/1462/36129/cvs2svn-1.5.1.tar.gz;
    md5 = "d1e42ea51b373be0023f2b3f6b80ec01";
  };

  buildInputs = [python bsddb3];

  buildPhase = "true";
  installPhase = "
    python ./setup.py install --prefix=$out

    source ${makeWrapper}
    mv $out/bin/cvs2svn $out/bin/.orig-cvs2svn
    makeWrapper $out/bin/.orig-cvs2svn $out/bin/cvs2svn \\
        --set PYTHONPATH \"$(toPythonPath $out):$(toPythonPath ${bsddb3}):$PYTHONPATH\"
  ";

  /* !!! maybe we should absolutise the program names in
     $out/lib/python2.4/site-packages/cvs2svn_lib/config.py. */
}