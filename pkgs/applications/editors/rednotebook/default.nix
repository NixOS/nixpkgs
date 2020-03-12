{ lib, buildPythonApplication, fetchFromGitHub
, gdk-pixbuf, glib, gobject-introspection, gtk3, gtksourceview, pango, webkitgtk
, pygobject3, pyyaml
}:

buildPythonApplication rec {
  pname = "rednotebook";
  version = "2.18";

  src = fetchFromGitHub {
    owner = "jendrikseipp";
    repo = "rednotebook";
    rev = "v${version}";
    sha256 = "1m75ns6vgycyi3zjlc9w2gnry1gyfz1jxhrklcxxi6aap0jxlgnr";
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

  # Until gobject-introspection in nativeBuildInputs is supported.
  # https://github.com/NixOS/nixpkgs/issues/56943#issuecomment-472568643
  strictDeps = false;

  meta = with lib; {
    homepage = "https://rednotebook.sourceforge.io/";
    description = "A modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej tstrobel ];
  };
}
