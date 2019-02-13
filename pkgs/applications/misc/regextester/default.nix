{ stdenv
, fetchFromGitHub
, gettext
, libxml2
, pkgconfig
, glib
, granite
, gtk3
, gnome3
, meson
, ninja
, gobject-introspection
, gsettings-desktop-schemas
, vala_0_40
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "regextester-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = "regextester";
    rev = version;
    sha256 = "1xwwv1hccni1mrbl58f7ly4qfq6738vn24bcbl2q346633cd7kx3";
  };

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    gettext
    gobject-introspection
    libxml2
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
    wrapGAppsHook
  ];
  buildInputs = [
    glib
    granite
    gtk3
    gnome3.defaultIconTheme
    gnome3.libgee
    gsettings-desktop-schemas
  ];

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "A desktop application to test regular expressions interactively";
    homepage = https://github.com/artemanufrij/regextester;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
