{ stdenv
, fetchFromGitHub
, meson
, ninja
, gettext
, pkgconfig
, python3
, wrapGAppsHook
, gobject-introspection
, gjs
, gtk3
, gsettings-desktop-schemas
, webkitgtk
, gdk_pixbuf
, glib
, desktop-file-utils
, hicolor-icon-theme /* setup hook */
, cairo
, libgee
, pantheon /* granite */
, libxml2
, libarchive
/*, hyphen */
, dict
}:

stdenv.mkDerivation rec {
  pname = "foliate";
  version = "1.5.2";

  # Fetch this from gnome mirror if/when available there instead!
  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = pname;
    rev = version;
    sha256 = "0jf4vgrrpg0s2nkj8rfmnkqpbdhsdipgmwgyxhhh5yvg4i78frl5";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    python3
    desktop-file-utils
    wrapGAppsHook
    hicolor-icon-theme
  ];
  buildInputs = [
    gdk_pixbuf
    glib
    gtk3
    gjs
    webkitgtk
    gsettings-desktop-schemas
    gobject-introspection
    cairo
    libgee
    pantheon.granite
    libxml2
    libarchive
    # TODO: Add once packaged, unclear how language packages best handled
    # hyphen
    dict # dictd for offline dictionary support
  ];

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  # Kludge so gjs can find resources by using the unwrapped name
  # Improvements/alternatives welcome, but this seems to work for now :/.
  # See: https://github.com/NixOS/nixpkgs/issues/31168#issuecomment-341793501
  postInstall = ''
    sed -e $'2iimports.package._findEffectiveEntryPointName = () => \'com.github.johnfactotum.Foliate\' ' \
      -i $out/bin/com.github.johnfactotum.Foliate

    # Also, create alias for sane usage from commandline, sheesh:
    ln -s $out/bin/com.github.johnfactotum.Foliate $out/bin/foliate
  '';

  meta = with stdenv.lib; {
    description = "Simple and modern GTK eBook reader";
    homepage = "https://johnfactotum.github.io/foliate/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
