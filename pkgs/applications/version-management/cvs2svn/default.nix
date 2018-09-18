{stdenv, lib, fetchurl, python2, cvs, makeWrapper}:

stdenv.mkDerivation rec {
  name = "cvs2svn-2.4.0";

  src = fetchurl {
    url = "http://cvs2svn.tigris.org/files/documents/1462/49237/${name}.tar.gz";
    sha256 = "05piyrcp81a1jgjm66xhq7h1sscx42ccjqaw30h40dxlwz1pyrx6";
  };

  buildInputs = [python2 makeWrapper];

  dontBuild = true;
  installPhase = ''
    python ./setup.py install --prefix=$out
    for i in bzr svn git; do
      wrapProgram $out/bin/cvs2$i \
          --prefix PATH : "${lib.makeBinPath [ cvs ]}" \
          --set PYTHONPATH "$(toPythonPath $out):$PYTHONPATH"
    done
  '';

  /* !!! maybe we should absolutise the program names in
     $out/lib/python2.4/site-packages/cvs2svn_lib/config.py. */

  meta = with stdenv.lib; {
    description = "A tool to convert CVS repositories to Subversion repositories";
    homepage = http://cvs2svn.tigris.org/;
    maintainers = [ maintainers.makefu ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
