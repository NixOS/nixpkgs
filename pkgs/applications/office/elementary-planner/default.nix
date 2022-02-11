{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, desktop-file-utils
, python3
, vala
, wrapGAppsHook
, libgee
, json-glib
, glib
, sqlite
, libgdata
, gtk3
, pantheon /* granite, icons */
, webkitgtk
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "elementary-planner";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planner";
    rev = version;
    sha256 = "sha256-Gba99ZNaQLAkHO/xGbXKljpph5Ckl+kXOsHVARRHkCo=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    libgee
    libhandy
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

  postFixup = ''
    ln -s $out/bin/com.github.alainm23.planner $out/bin/planner
  '';

  meta = with lib; {
    description = "Task manager with Todoist support designed for GNU/Linux";
    homepage = "https://planner-todo.web.app";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.alainm23.planner";
  };
}
