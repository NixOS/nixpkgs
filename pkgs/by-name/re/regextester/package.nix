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
, desktop-file-utils
, pantheon
, wrapGAppsHook3 }:

stdenv.mkDerivation rec {
  pname = "regextester";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "artemanufrij";
    repo = "regextester";
    rev = version;
    hash = "sha256-5+gU8DeB99w2h/4vMal2eHkR0305dmRYiY6fsLZzlnc=";
  };

  nativeBuildInputs = [
    vala
    gettext
    gobject-introspection
    libxml2
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    desktop-file-utils
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
    description = "Desktop application to test regular expressions interactively";
    mainProgram = "com.github.artemanufrij.regextester";
    homepage = "https://github.com/artemanufrij/regextester";
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
