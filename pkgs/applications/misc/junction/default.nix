{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, gobject-introspection
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gjs
, gtk4
, libadwaita
, libportal-gtk4
}:

stdenv.mkDerivation rec {
  pname = "junction";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "junction";
    rev = "v${version}";
    sha256 = "sha256-jS4SHh1BB8jk/4EP070X44C4n3GjyCz8ozgK8v5lbqc=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    gtk4
    libadwaita
    libportal-gtk4
  ];

  postInstall = ''
    # autoPatchShebangs does not like "/usr/bin/env -S gjs"
    substituteInPlace $out/bin/re.sonny.Junction --replace "/usr/bin/env -S gjs" "/usr/bin/gjs"
  '';

  meta = with lib; {
    description = "Choose the application to open files and links";
    homepage = "https://apps.gnome.org/en/app/re.sonny.Junction/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hqurve ];
    platforms = platforms.linux;
  };
}
