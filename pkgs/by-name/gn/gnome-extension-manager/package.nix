{ stdenv
, lib
, fetchFromGitHub
, wrapGAppsHook4
, libadwaita
, meson
, ninja
, gettext
, gtk4
, appstream
, appstream-glib
, desktop-file-utils
, gobject-introspection
, blueprint-compiler
, pkg-config
, json-glib
, libsoup_3
, glib
, libbacktrace
, text-engine
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "gnome-extension-manager";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = "extension-manager";
    rev = "v${version}";
    hash = "sha256-PWpnLtzQDF2Is63CY9bNzYSo+MiA2oxzJi7B4nQZ7v8=";
  };

  nativeBuildInputs = [
    appstream
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    blueprint-compiler
    gtk4
    json-glib
    libadwaita
    libsoup_3
    libbacktrace
    text-engine
  ];

  patches = [
    # fix black window when opened, remove in next release
    (fetchpatch {
      url = "https://github.com/mjakeman/extension-manager/commit/91d1c42a30e12131dc3c5afd8a709e7db2a95b70.patch";
      hash = "sha256-NtsJeqclUx4L3wbyQ46ZCoo4IKSu4/HoT/FD20xriZ4=";
    })
  ];

  mesonFlags = [
    (lib.mesonOption "package" "Nix")
    (lib.mesonOption "distributor" "nixpkgs")
  ];

  meta = with lib; {
    description = "Desktop app for managing GNOME shell extensions";
    homepage = "https://github.com/mjakeman/extension-manager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "extension-manager";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
