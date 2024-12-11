{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  gtksourceview,
  pango,
  webkitgtk_4_0,
  pygobject3,
  pyyaml,
  setuptools,
}:

buildPythonApplication rec {
  pname = "rednotebook";
  version = "2.36";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jendrikseipp";
    repo = "rednotebook";
    tag = "v${version}";
    sha256 = "sha256-ISwYQPI7qM0+cEdWnHLdrJA/07BUjDP4gzF/GzqNcsE=";
  };

  # We have not packaged tests.
  doCheck = false;

  nativeBuildInputs = [ gobject-introspection ];

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    gdk-pixbuf
    glib
    gtk3
    gtksourceview
    pango
    webkitgtk_4_0
    pygobject3
    pyyaml
  ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
    "--prefix XDG_DATA_DIRS : $out/share"
    "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  ];

  pythonImportsCheck = [ "rednotebook" ];

  meta = with lib; {
    homepage = "https://rednotebook.sourceforge.io/";
    changelog = "https://github.com/jendrikseipp/rednotebook/blob/v${version}/CHANGELOG.md";
    description = "Modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    mainProgram = "rednotebook";
  };
}
