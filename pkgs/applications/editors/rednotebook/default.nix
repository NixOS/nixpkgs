{ lib, buildPythonApplication, fetchFromGitHub
, gdk_pixbuf, glib, gtk3, pango, webkitgtk
, pygobject3, pyyaml
}:

buildPythonApplication rec {
  name = "rednotebook-${version}";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "jendrikseipp";
    repo = "rednotebook";
    rev = "v${version}";
    sha256 = "0zkfid104hcsf20r6829v11wxdghqkd3j1zbgyvd1s7q4nxjn5lj";
  };

  # We have not packaged tests.
  doCheck = false;

  propagatedBuildInputs = [
    gdk_pixbuf glib gtk3 pango webkitgtk
    pygobject3 pyyaml
  ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
    "--prefix XDG_DATA_DIRS : $out/share"
    "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  ];

  meta = with lib; {
    homepage = http://rednotebook.sourceforge.net/;
    description = "A modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej tstrobel ];
  };
}
