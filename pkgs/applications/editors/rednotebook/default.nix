{ lib, buildPythonApplication, fetchFromGitHub
, gdk-pixbuf, glib, gobject-introspection, gtk3, gtksourceview, pango, webkitgtk
, pygobject3, pyyaml
}:

buildPythonApplication rec {
  pname = "rednotebook";
  version = "2.33";

  src = fetchFromGitHub {
    owner = "jendrikseipp";
    repo = "rednotebook";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-K4uEZZZXU2mZ61t6Ak5mpiCsm/mcNhm+xJSzfJPiuwo=";
  };

  # We have not packaged tests.
  doCheck = false;

  nativeBuildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [
    gdk-pixbuf glib gtk3 gtksourceview pango webkitgtk
    pygobject3 pyyaml
  ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
    "--prefix XDG_DATA_DIRS : $out/share"
    "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  ];

  meta = with lib; {
    homepage = "https://rednotebook.sourceforge.io/";
    changelog = "https://github.com/jendrikseipp/rednotebook/blob/v${version}/CHANGELOG.md";
    description = "Modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    mainProgram = "rednotebook";
  };
}
