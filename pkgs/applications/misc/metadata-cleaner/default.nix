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
  version = "2.2.2";

  format = "other";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "metadata-cleaner";
    rev = "v${version}";
    hash = "sha256-V3qcQQwc2ykVTVgUJuNnVQ9iSPD0tv4C2hSILLxuE70=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    glib
    gtk4
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gobject-introspection
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
    license = with licenses; [ gpl3Plus cc-by-sa-40 ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
