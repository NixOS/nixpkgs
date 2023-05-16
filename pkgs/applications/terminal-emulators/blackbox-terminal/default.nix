{ lib
, stdenv
, fetchFromGitLab
<<<<<<< HEAD
, fetchpatch
=======
, fetchurl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
, libgee
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
<<<<<<< HEAD
  version = "0.14.0";
=======
  version = "0.13.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "blackbox";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ebwh9WTooJuvYFIygDBn9lYC7+lx9P1HskvKU8EX9jw=";
  };

  patches = [
    # Fix closing confirmation dialogs not showing
    (fetchpatch {
      url = "https://gitlab.gnome.org/raggesilver/blackbox/-/commit/3978c9b666d27adba835dd47cf55e21515b6d6d9.patch";
      hash = "sha256-L/Ci4YqYNzb3F49bUwEWSjzr03MIPK9A5FEJCCct+7A=";
    })
  ];

=======
    hash = "sha256-WeR7zdYdRWBR+kmxLjRFE6QII9RdBig7wrbVoCPA5go=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    libgee
  ];

<<<<<<< HEAD
  mesonFlags = [ "-Dblackbox_is_flatpak=false" ];

  meta = with lib; {
    description = "Beautiful GTK 4 terminal";
    mainProgram = "blackbox";
=======
  meta = with lib; {
    description = "Beautiful GTK 4 terminal";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://gitlab.gnome.org/raggesilver/blackbox";
    changelog = "https://gitlab.gnome.org/raggesilver/blackbox/-/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
