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
, wrapGAppsHook4
, gobject-introspection
, libadwaita
, librsvg
, gtk4
}:

python3.pkgs.buildPythonApplication rec {
  pname = "banking";
  version = "0.6.0";
  format = "other";

  src = fetchFromGitLab {
    owner = "tabos";
    repo = "banking";
    rev = version;
    hash = "sha256-x/um40sRD58d5LuuJlyietCV1Rw4H5VSO0I3ZwD5kO8=";
  };

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
    wrapGAppsHook4
    gobject-introspection
    gtk4 # for gtk4-update-icon-cache
  ];

  buildInputs = [
    libadwaita
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cryptography
    fints
    mt-940
    onetimepad
    pygobject3
    schwifty
  ];

  meta = with lib; {
    description = "Banking application for small screens";
    homepage = "https://tabos.gitlab.io/projects/banking/";
    license = licenses.gpl3Plus;
    mainProgram = "org.tabos.banking";
    maintainers = with maintainers; [ dotlambda ];
  };
}
