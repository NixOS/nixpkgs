{ lib
, python3
, fetchFromGitLab
, appstream
, desktop-file-utils
, glib
, gobject-introspection
, gtk4
, itstool
, libadwaita
, librsvg
, meson
, ninja
, pkg-config
, poppler_gi
, wrapGAppsHook4
}:

python3.pkgs.buildPythonApplication rec {
  pname = "metadata-cleaner";
  version = "2.5.4";

  format = "other";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2+ZY+ca/CTIdCiFrBOkMWKflzKjSYJ8yfwFkULNg7Xk=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    glib # glib-compile-resources
    gtk4 # gtk4-update-icon-cache
    gobject-introspection
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
    poppler_gi
  ];

  propagatedBuildInputs = with python3.pkgs; [
    mat2
    pygobject3
  ];

  meta = with lib; {
    description = "Python GTK application to view and clean metadata in files, using mat2";
    homepage = "https://gitlab.com/rmnvgr/metadata-cleaner";
    changelog = "https://gitlab.com/rmnvgr/metadata-cleaner/-/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ gpl3Plus cc-by-sa-40 ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
