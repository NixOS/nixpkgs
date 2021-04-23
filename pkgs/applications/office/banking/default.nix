{ lib
, fetchurl
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
    homepage = "https://tabos.gitlab.io/project/banking/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
