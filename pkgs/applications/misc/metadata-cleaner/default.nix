{ lib
, python3
, fetchFromGitLab
, appstream
, desktop-file-utils
, glib
, gobject-introspection
, gtk3
, libhandy
, librsvg
, meson
, ninja
, pkg-config
, poppler_gi
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "metadata-cleaner";
  version = "1.0.7";

  format = "other";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "metadata-cleaner";
    rev = "v${version}";
    sha256 = "sha256-HlP/QahVFCAct06pKanjozFqeyTdHoHanIemq5ID2CQ=";
  };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    glib
    gtk3
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    libhandy
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
