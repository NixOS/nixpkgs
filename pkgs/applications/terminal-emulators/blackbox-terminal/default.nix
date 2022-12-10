{ lib
, stdenv
, fetchFromGitLab
, fetchurl
, meson
, ninja
, pkg-config
, vala
, gtk4
, vte-gtk4
, json-glib
, sassc
, libadwaita
, pcre2
, libxml2
, librsvg
, callPackage
, python3
, gtk3
, desktop-file-utils
, wrapGAppsHook
}:

let
  marble = callPackage ./marble.nix { };
in
stdenv.mkDerivation rec {
  pname = "blackbox";
  version = "0.12.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "blackbox";
    rev = "v${version}";
    sha256 = "sha256-4/rtviBv5KXheLLExxOvaF0wU87eRKMNxlYCVxuIQgU=";
  };

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    sassc
    wrapGAppsHook
    python3
    gtk3 # For gtk-update-icon-cache
    desktop-file-utils # For update-desktop-database
  ];
  buildInputs = [
    gtk4
    vte-gtk4
    json-glib
    marble
    libadwaita
    pcre2
    libxml2
    librsvg
  ];

  meta = with lib; {
    description = "Beautiful GTK 4 terminal";
    homepage = "https://gitlab.gnome.org/raggesilver/blackbox";
    changelog = "https://gitlab.gnome.org/raggesilver/blackbox/-/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
