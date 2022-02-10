{ lib, stdenv, fetchFromGitHub
, meson, pkg-config, ninja
, python3
, glib, appstream-glib , desktop-file-utils
, gobject-introspection, gtk3
, wrapGAppsHook
, libhandy, webkitgtk, glib-networking
, gnome, dconf
}:
let
  pythonEnv = python3.withPackages (p: with p; [
    pygobject3
    requests
  ]);
in stdenv.mkDerivation rec {
  pname = "wike";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "hugolabe";
    repo = "Wike";
    rev = version;
    sha256 = "sha256-QLhfzGRrc2En0Hu+UdtPM572PdtXqOFL0W3LoAki4jI=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    appstream-glib
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    pythonEnv
    gtk3
    libhandy
    webkitgtk
    glib-networking
    gnome.adwaita-icon-theme
    dconf
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
    substituteInPlace src/wike.in    --replace "@PYTHON@" "${pythonEnv}/bin/python"
    substituteInPlace src/wike-sp.in --replace "@PYTHON@" "${pythonEnv}/bin/python"
  '';

  meta = with lib; {
    description = "Wikipedia Reader for the GNOME Desktop";
    homepage = "https://github.com/hugolabe/Wike";
    license = licenses.gpl3Plus;
    platforms = webkitgtk.meta.platforms;
    maintainers = with maintainers; [ samalws ];
  };
}
