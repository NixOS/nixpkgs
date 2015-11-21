{ stdenv, fetchurl, buildPythonPackage, gnome, librsvg, pygtk, pythonPackages }:

buildPythonPackage rec {
  name = "key-mon-${version}";
  version = "1.17";
  namePrefix = "";

  src = fetchurl {
    url = "http://key-mon.googlecode.com/files/${name}.tar.gz";
    sha256 = "1liz0dxcqmchbnl1xhlxkqm3gh76wz9jxdxn9pa7dy77fnrjkl5q";
  };

  propagatedBuildInputs =
    [ gnome.python_rsvg librsvg pygtk pythonPackages.xlib ];

  doCheck = false;

  makeWrapperArgs = ''
    --set GDK_PIXBUF_MODULE_FILE ${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache
  '';

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/key-mon;
    description = "Utility to show live keyboard and mouse status for teaching and screencasts";
    license = licenses.asl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
