{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, desktop-file-utils
, python3
, vala
, wrapGAppsHook
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
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planner";
    rev = version;
    sha256 = "0q5zmjh0d1mapgqb2a38spss280jkkc2n835kc7grzvs9jgq1k1k";
  };

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

  preFixup = ''
    gappsWrapperArgs+=(
      # the theme is hardcoded
      --prefix XDG_DATA_DIRS : "${pantheon.elementary-gtk-theme}/share"
    )
  '';

  meta = with stdenv.lib; {
    description = "Task manager with Todoist support designed for GNU/Linux 🚀️";
    homepage = "https://planner-todo.web.app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ] ++ pantheon.maintainers;
  };
}

