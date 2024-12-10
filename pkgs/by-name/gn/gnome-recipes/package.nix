{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, desktop-file-utils
, gettext
, itstool
, python3
, wrapGAppsHook3
, gtk3
, glib
, libsoup_2_4
, gnome-online-accounts
, librest
, json-glib
, gnome-autoar
, gspell
, libcanberra
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "gnome-recipes";
  version = "2.0.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "recipes";
    rev = version;
    fetchSubmodules = true;
    sha256 = "GyFOwEYmipQdFLtTXn7+NvhDTzxBlOAghr3cZT4QpQw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    gettext
    itstool
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    libsoup_2_4
    gnome-online-accounts
    librest
    json-glib
    gnome-autoar
    gspell
    libcanberra
  ];

  postPatch = ''
    chmod +x src/list_to_c.py
    patchShebangs src/list_to_c.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Recipe management application for GNOME";
    mainProgram = "gnome-recipes";
    homepage = "https://gitlab.gnome.org/GNOME/recipes";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
