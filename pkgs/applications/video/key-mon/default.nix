{ stdenv, fetchurl, gnome2, librsvg, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "key-mon-${version}";
  version = "1.17";
  namePrefix = "";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/key-mon/${name}.tar.gz";
    sha256 = "1liz0dxcqmchbnl1xhlxkqm3gh76wz9jxdxn9pa7dy77fnrjkl5q";
  };

  propagatedBuildInputs =
    [ gnome2.python_rsvg librsvg pythonPackages.pygtk pythonPackages.xlib ];

  doCheck = false;

  preFixup = ''
      export makeWrapperArgs="--set GDK_PIXBUF_MODULE_FILE $GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    homepage = https://code.google.com/archive/p/key-mon;
    description = "Utility to show live keyboard and mouse status for teaching and screencasts";
    license = licenses.asl20;
    maintainers = [ maintainers.goibhniu ];
  };
}
