{ stdenv
, fetchFromGitHub
, gettext
, libxml2
, pkgconfig
, gtk3
, granite
, gnome3
, meson
, ninja
, gobjectIntrospection
, gsettings-desktop-schemas
, vala
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
    gobjectIntrospection
    libxml2
    vala
    wrapGAppsHook
  ];
  buildInputs = [
    gtk3
    granite
    gnome3.defaultIconTheme
    gnome3.glib
    gnome3.libgee
    gsettings-desktop-schemas
  ];

  postInstall = ''
    ${gnome3.glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "A desktop application to test regular expressions interactively";
    homepage = https://github.com/artemanufrij/regextester;
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
