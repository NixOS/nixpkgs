{ lib, stdenv
, fetchFromGitHub
, vala
, gettext
, libxml2
, pkg-config
, glib
, gtk3
, libgee
, meson
, ninja
, gobject-introspection
, gsettings-desktop-schemas
, pantheon
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "regextester";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = "regextester";
    rev = version;
    sha256 = "1xwwv1hccni1mrbl58f7ly4qfq6738vn24bcbl2q346633cd7kx3";
  };

  nativeBuildInputs = [
    vala
    gettext
    gobject-introspection
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.granite
    glib
    libgee
    gsettings-desktop-schemas
    gtk3
  ];

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "A desktop application to test regular expressions interactively";
    homepage = "https://github.com/artemanufrij/regextester";
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
