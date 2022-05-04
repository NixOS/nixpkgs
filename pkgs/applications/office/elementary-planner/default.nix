{ lib, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, desktop-file-utils
, python3
, vala
, wrapGAppsHook
, evolution-data-server
, libical
, libgee
, json-glib
, glib
, glib-networking
, sqlite
, libsoup
, libgdata
, gtk3
, pantheon /* granite, icons, maintainers */
, webkitgtk
, libpeas
, libhandy
, curl
}:

stdenv.mkDerivation rec {
  pname = "elementary-planner";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "alainm23";
    repo = "planner";
    rev = version;
    sha256 = "sha256-3eFPGRcZWhzFYi52TbHmpFNLI0pWYcHbbBI7efqZwYE=";
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
    evolution-data-server
    glib
    glib-networking
    gtk3
    json-glib
    libgee
    libical
    libpeas
    libsoup
    pantheon.elementary-icon-theme
    pantheon.granite
    sqlite
    webkitgtk
    libhandy
    curl
  ];

  postPatch = ''
    # The GTK theme has been renamed in elementary OS 6
    # https://github.com/elementary/flatpak-platform/blob/6.1.0/io.elementary.Sdk.json#L182
    # Remove this in https://github.com/NixOS/nixpkgs/pull/159249
    substituteInPlace src/Application.vala \
      --replace '"gtk-theme-name", "elementary"' '"gtk-theme-name", "io.elementary.stylesheet.blueberry"'

    # Fix build with vala 0.56
    # https://github.com/alainm23/planner/pull/884
    substituteInPlace src/Application.vala \
      --replace "public const OptionEntry[] PLANNER_OPTIONS" "private const OptionEntry[] PLANNER_OPTIONS"

    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # The GTK theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${pantheon.elementary-gtk-theme}/share"
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  postFixup = ''
    ln -s $out/bin/com.github.alainm23.planner $out/bin/planner
  '';

  meta = with lib; {
    description = "Task manager with Todoist support designed for GNU/Linux 🚀️";
    homepage = "https://planner-todo.web.app";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ] ++ teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "com.github.alainm23.planner";
  };
}

