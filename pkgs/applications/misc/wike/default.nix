{ lib, stdenv, fetchFromGitHub
, meson, pkg-config, ninja
, python3
, glib, appstream-glib , desktop-file-utils
, gobject-introspection, gtk3
, wrapGAppsHook
, libhandy, webkitgtk, glib-networking
, gnome, dconf
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wike";
  version = "1.7.1";
  format = "other";
  strictDeps = false; # https://github.com/NixOS/nixpkgs/issues/56943

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
    gtk3
    libhandy
    webkitgtk
    glib-networking
    gnome.adwaita-icon-theme
    dconf
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    pygobject3
  ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Wikipedia Reader for the GNOME Desktop";
    homepage = "https://github.com/hugolabe/Wike";
    license = licenses.gpl3Plus;
    platforms = webkitgtk.meta.platforms;
    maintainers = with maintainers; [ samalws ];
  };
}
