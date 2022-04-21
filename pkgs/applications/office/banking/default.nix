{ lib
, fetchpatch
, fetchFromGitLab
, python3
, appstream-glib
, desktop-file-utils
, glib
, libxml2
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gobject-introspection
, libadwaita
, librsvg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "banking";
  version = "0.4.0";
  format = "other";

  src = fetchFromGitLab {
    owner = "tabos";
    repo = "banking";
    rev = version;
    sha256 = "sha256-VGNCSirQslRfLIFeo375BNlHujoNXm+s55Ty+hB+ZRI=";
  };

  patches = [
    # Fix build with meson 0.61
    # https://gitlab.com/tabos/banking/-/merge_requests/90
    (fetchpatch {
      url = "https://gitlab.com/tabos/banking/-/commit/c3cc9afc380fe666ae6e331aa8a97659c60397a4.patch";
      sha256 = "r9n9l47XU4Tg4U5sfiFdGkbG8QB7O4ol9CB1ya06yOc=";
    })
    # fix build with libadwaita 1.0.0
    (fetchpatch {
      url = "https://gitlab.com/tabos/banking/-/commit/27ac4a89ba6047005d43de71a469ef30d1fda8b5.patch";
      hash = "sha256-dpDjdYf3gDsyFMTfGes+x27yUxKEnKjLulJxX2encG0=";
    })
  ];

  postPatch = ''
    patchShebangs meson_post_conf.py meson_post_install.py
  '';

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    desktop-file-utils # for desktop-file-validate
    glib # for glib-compile-resources
    libxml2 # for xmllint
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    libadwaita
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
