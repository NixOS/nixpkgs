{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, appstream-glib, desktop-file-utils
, python3, vala, wrapGAppsHook
, evolution-data-server
, libical
, libgee
, json-glib
, sqlite
, libsoup
, gtk3
, pantheon /* granite, schemas */
, webkitgtk
, appstream
}:

stdenv.mkDerivation rec {
  pname = "planner";
  version = "2.1.1";
  src = fetchFromGitHub {
    owner = "alainm23";
    repo = pname;
    rev = version;
    sha256 = "0swj94pqf00wwzsgjap8z19k33gg1wj2b78ba1aj9h791j8lmaim";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    evolution-data-server
    libical
    libgee
    json-glib
    sqlite
    libsoup
    gtk3
    pantheon.granite
    webkitgtk
    appstream
    pantheon.elementary-gsettings-schemas
    pantheon.elementary-icon-theme
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py

    # Fix version string not updated in this release.
    # (please check if still needed when updating!)
    substituteInPlace src/Dialogs/Preferences.vala \
      --replace v2.0.8 v${version}
  '';

  meta = with stdenv.lib; {
    description = "Task and project manager designed to elementary OS";
    homepage = "https://planner-todo.web.app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

