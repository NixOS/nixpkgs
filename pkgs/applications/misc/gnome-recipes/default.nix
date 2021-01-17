{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gnome3
, desktop-file-utils
, gettext
, itstool
, python3
, wrapGAppsHook
, gtk3
, glib
, libsoup
, gnome-online-accounts
, librest
, json-glib
, gnome-autoar
, gspell
, libcanberra }:

let
  pname = "gnome-recipes";
  version = "2.0.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1yymii3yf823d9x28fbhqdqm1wa30s40j94x0am9fjj0nzyd5s8v";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    gettext
    itstool
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    glib
    libsoup
    gnome-online-accounts
    librest
    json-glib
    gnome-autoar
    gspell
    libcanberra
  ];

  # https://github.com/NixOS/nixpkgs/issues/36468
  # https://gitlab.gnome.org/GNOME/recipes/issues/76
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  postPatch = ''
    chmod +x src/list_to_c.py
    patchShebangs src/list_to_c.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Recipe management application for GNOME";
    homepage = "https://wiki.gnome.org/Apps/Recipes";
    maintainers = teams.gnome.members;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
