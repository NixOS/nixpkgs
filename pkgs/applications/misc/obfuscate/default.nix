{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, wrapGAppsHook
, pkg-config
, gtk4
, glib
, gdk-pixbuf
, rustPlatform
, desktop-file-utils
, appstream-glib
, python3
, librsvg
, libadwaita
}:

rustPlatform.buildRustPackage rec {
  pname = "obfuscate";
  version = "0.0.4"; # latest tag v0.0.2 is broken

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "obfuscate";
    rev = "dbbb44037b10b223e95e85d6025c2f8337b868fd";
    hash = "sha256-P8Y2Eizn1BMZXuFjGMXF/3oAUzI8ZNTrnbLyU+V6uk4=";
  };

  cargoHash = "sha256-eKXVN3PHgeLeG4qxh30VhyMX0FMOO/ZlZ8trUGIs2sc=";

  nativeBuildInputs = [
    meson
    ninja
    glib
    gtk4
    gdk-pixbuf
    wrapGAppsHook
    pkg-config
    desktop-file-utils
    appstream-glib
    python3
  ];

  buildInputs = [
    gtk4
    glib
    librsvg
    gdk-pixbuf
    libadwaita
  ];

  buildPhase = ''
    patchShebangs build-aux/meson_post_install.py
    mesonConfigurePhase
    ninjaBuildPhase
  '';

  installPhase = ''
    ninjaInstallPhase
  '';

  meta = with lib; {
    description = "Censor private information";
    homepage = "https://gitlab.gnome.org/World/obfuscate";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.mkg20001 ];
    platforms = platforms.unix;
  };
}
