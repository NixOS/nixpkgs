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
  webkitgtk_4_1,
  pygobject3,
  pyyaml,
  setuptools,
}:

buildPythonApplication rec {
  pname = "rednotebook";
  version = "2.42";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jendrikseipp";
    repo = "rednotebook";
    tag = "v${version}";
    sha256 = "sha256-4e3LvBVrhqzNja9kOZ5xJVYvwjGkKNvIuXou4YfD6w4=";
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
    webkitgtk_4_1
    pygobject3
    pyyaml
  ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
    "--prefix XDG_DATA_DIRS : $out/share"
    "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  ];

  pythonImportsCheck = [ "rednotebook" ];

  meta = {
    homepage = "https://rednotebook.sourceforge.io/";
    changelog = "https://github.com/jendrikseipp/rednotebook/blob/${src.tag}/CHANGELOG.md";
    description = "Modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "rednotebook";
  };
}
