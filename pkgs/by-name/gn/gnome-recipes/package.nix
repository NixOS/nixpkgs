{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  gettext,
  itstool,
  python3,
  wrapGAppsHook3,
  gtk3,
  glib,
  libsoup_2_4,
  gnome-online-accounts,
  librest,
  json-glib,
  gnome-autoar,
  gspell,
  libcanberra,
  nix-update-script,
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

  patches = [
    # gcc-14 build failure fix
    (fetchpatch {
      name = "gcc-14.patch";
      url = "https://gitlab.gnome.org/GNOME/recipes/-/commit/c0304675f63a33737b24fdf37e06c6b154a91a31.patch";
      hash = "sha256-YTf4NDwUiU/q96RAXKTO499pW9sPrgh8IvdPBPEnV6Q=";
    })
  ];

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
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
