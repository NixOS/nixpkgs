{ stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkgconfig, desktop-file-utils
, python3, vala, wrapGAppsHook
, evolution-data-server
, libical
, libgee
, json-glib
, glib
, sqlite
, libsoup
, gtk3
, pantheon /* granite, icons, maintainers */
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "elementary-planner";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planner";
    rev = version;
    sha256 = "1kjk1zafx71zmax3whzpx6mzl037wlxri30bl2k9y9rg3fd09arr";
  };

  patches = [
    # Revert a patch the works around some stylesheet issues:
    # https://github.com/alainm23/planner/issues/268
    # https://github.com/alainm23/planner/issues/303
    # The don't seem to be a problem with Pantheon on NixOS
    # and for some reason produce the opposite effect with
    # pantheon's stylesheet.
    ./0001-Revert-Add-patch.patch
  ];

  nativeBuildInputs = [
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
    glib
    gtk3
    json-glib
    libgee
    libical
    libsoup
    pantheon.elementary-icon-theme
    pantheon.granite
    sqlite
    webkitgtk
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Task and project manager designed to elementary OS";
    homepage = "https://planner-todo.web.app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ] ++ pantheon.maintainers;
  };
}

