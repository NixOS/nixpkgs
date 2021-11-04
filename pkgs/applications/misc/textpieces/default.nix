{ lib
, stdenv
, fetchFromGitHub
, python39
, appstream-glib
, desktop-file-utils
, gtk3
, gtksourceview5
, gobject-introspection
, meson
, ninja
, pkg-config
, vala
, wrapGAppsHook4
, glib
, gtk4
, json-glib
, libadwaita
, libgee
, wayland
, nix-update-script
}:
let
  pythonEnv = python39.withPackages (p: [ p.pyyaml ]);
in
stdenv.mkDerivation rec {
  pname = "textpieces";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "liferooter";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x0zUx8RhSI4mulbv/zTWV7OGNI0gbcdf9pgl0bwH71w=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gtk3 # for gtk-update-icon-cache
    gtksourceview5
    gobject-introspection
    meson
    ninja
    pkg-config
    pythonEnv
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    libadwaita
    libgee
    wayland
  ];

  runtimeDependencies = [
    pythonEnv
  ];

  postPatch = ''
    patchShebangs build-aux/meson/
    patchShebangs scripts/
  '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "A GTK4 app for quick text transformations";
    longDescription = "A small tool for quick text transformations such as checksums, encoding, decoding and so on.";
    homepage = "https://github.com/liferooter/textpieces";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bree ];
    mainProgram = "com.github.liferooter.textpieces";
  };
}
