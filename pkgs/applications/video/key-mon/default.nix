{ stdenv, fetchurl, buildPythonPackage, gnome, librsvg, makeWrapper, pygtk
, pythonPackages }:

buildPythonPackage rec {
  name = "key-mon-${version}";
  version = "1.13";
  namePrefix = "";

  src = fetchurl {
    url = "http://key-mon.googlecode.com/files/${name}.tar.gz";
    sha256 = "02h7lcnyqwyqsycd1vlvl11ms81v0zmr9p0pfyl5gmzry9dj7imj";
  };

  propagatedBuildInputs =
    [ gnome.python_rsvg librsvg makeWrapper pygtk pythonPackages.xlib ];

  doCheck = false;

  postInstall = ''
      wrapProgram $out/bin/key-mon --prefix GDK_PIXBUF_MODULE_FILE : \
      ${librsvg}/lib/gdk-pixbuf/loaders.cache
    '';

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/key-mon;
    description = "Utility to show live keyboard and mouse status for teaching and screencasts";
    license = licenses.asl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
