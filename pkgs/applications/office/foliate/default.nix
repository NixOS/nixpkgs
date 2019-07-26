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
, glib
, desktop-file-utils
, hicolor-icon-theme /* setup hook */
, libarchive
/*, hyphen */
, dict
}:

stdenv.mkDerivation rec {
  pname = "foliate";
  version = "1.5.3";

  # Fetch this from gnome mirror if/when available there instead!
  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = pname;
    rev = version;
    sha256 = "1bjlk9n1j34yx3bvzl95mpb56m2fjc5xcd6yks96pwfyfvjnbp93";
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
    glib
    gtk3
    gjs
    webkitgtk
    gsettings-desktop-schemas
    gobject-introspection
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
  '';

  meta = with stdenv.lib; {
    description = "Simple and modern GTK eBook reader";
    homepage = "https://johnfactotum.github.io/foliate/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dtzWill ];
  };
}
