{ lib, buildPythonApplication, fetchFromGitHub
, gdk_pixbuf, glib, gobjectIntrospection, gtk3, pango, webkitgtk
, pygobject3, pyyaml
}:

buildPythonApplication rec {
  pname = "rednotebook";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "jendrikseipp";
    repo = "rednotebook";
    rev = "v${version}";
    sha256 = "1x6acx0hagsawx84cv55qz17p8qjpq1v1zaf8rmm6ifsslsxw91h";
  };

  # We have not packaged tests.
  doCheck = false;

  nativeBuildInputs = [ gobjectIntrospection ];

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
