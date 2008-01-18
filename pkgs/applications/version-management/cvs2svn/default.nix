{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation {
  name = "cvs2svn-2.0.1";

  src = fetchurl {
    url = http://cvs2svn.tigris.org/files/documents/1462/39919/cvs2svn-2.0.1.tar.gz;
    sha256 = "1pgbyxzgn22lnw3h5c2nd8z46pkk863jg3fgh9pqa1jihsx1cg1j";
  };

  buildInputs = [python makeWrapper];

  buildPhase = "true";
  installPhase = ''
    python ./setup.py install --prefix=$out
    wrapProgram $out/bin/cvs2svn \
        --set PYTHONPATH "$(toPythonPath $out):$PYTHONPATH"
  '';

  /* !!! maybe we should absolutise the program names in
     $out/lib/python2.4/site-packages/cvs2svn_lib/config.py. */

  meta = {
    description = "A tool to convert CVS repositories to Subversion repositories";
    homepage = http://cvs2svn.tigris.org/;
  };
}
