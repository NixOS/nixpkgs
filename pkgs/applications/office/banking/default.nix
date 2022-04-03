{ lib
, fetchpatch
, fetchFromGitLab
, python3
, appstream-glib
, desktop-file-utils
, glib
, gtk3
, libxml2
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gobject-introspection
, libhandy
, librsvg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "banking";
  version = "0.3.0";
  format = "other";

  src = fetchFromGitLab {
    owner = "tabos";
    repo = "banking";
    rev = version;
    sha256 = "1w5x9iczw5hb9bfdm1df37n8xhdrida1yfrd82k9l8hb1k4q3h9d";
  };

  patches = [
    # Fix build with meson 0.61
    # https://gitlab.com/tabos/banking/-/merge_requests/90
    (fetchpatch {
      url = "https://gitlab.com/tabos/banking/-/commit/c3cc9afc380fe666ae6e331aa8a97659c60397a4.patch";
      sha256 = "r9n9l47XU4Tg4U5sfiFdGkbG8QB7O4ol9CB1ya06yOc=";
    })
  ];

  postPatch = ''
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    desktop-file-utils # for desktop-file-validate
    glib # for glib-compile-resources
    gtk3 # for gtk-update-icon-cache
    libxml2 # for xmllint
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
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cryptography
    fints
    mt-940
    pygobject3
  ];

  meta = with lib; {
    description = "Banking application for small screens";
    homepage = "https://tabos.gitlab.io/projects/banking/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
