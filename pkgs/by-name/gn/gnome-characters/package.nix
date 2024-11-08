{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  gnome,
  glib,
  gtk4,
  pango,
  wrapGAppsHook4,
  desktop-file-utils,
  gobject-introspection,
  gjs,
  libunistring,
  libadwaita,
  gsettings-desktop-schemas,
  gnome-desktop,
}:

stdenv.mkDerivation rec {
  pname = "gnome-characters";
  version = "47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${lib.versions.major version}/gnome-characters-${version}.tar.xz";
    hash = "sha256-a88Foi8w8THYqANbD2PYapVnAHpfbfXOhVa6Bnd7dXQ=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    glib
    gnome-desktop # for typelib
    gsettings-desktop-schemas
    gtk4
    libunistring
    libadwaita
    pango
  ];

  dontWrapGApps = true;

  postFixup = ''
    # Fixes https://github.com/NixOS/nixpkgs/issues/31168
    file="$out/share/org.gnome.Characters/org.gnome.Characters"
    sed -e $"2iimports.package._findEffectiveEntryPointName = () => \'$(basename $file)\' " \
      -i $file
    wrapGApp "$file"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-characters"; };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Characters/";
    description = "Simple utility application to find and insert unusual characters";
    mainProgram = "gnome-characters";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
