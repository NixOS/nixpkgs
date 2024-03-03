{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
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
, libsixel
, libxml2
, librsvg
, libgee
, callPackage
, python3
, gtk3
, desktop-file-utils
, wrapGAppsHook
, sixelSupport ? false
}:

let
  marble = callPackage ./marble.nix { };
in
stdenv.mkDerivation rec {
  pname = "blackbox";
  version = "0.14.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "blackbox";
    rev = "v${version}";
    hash = "sha256-ebwh9WTooJuvYFIygDBn9lYC7+lx9P1HskvKU8EX9jw=";
  };

  patches = [
    # Fix closing confirmation dialogs not showing
    (fetchpatch {
      url = "https://gitlab.gnome.org/raggesilver/blackbox/-/commit/3978c9b666d27adba835dd47cf55e21515b6d6d9.patch";
      hash = "sha256-L/Ci4YqYNzb3F49bUwEWSjzr03MIPK9A5FEJCCct+7A=";
    })
  ];

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
    (vte-gtk4.overrideAttrs (old: {
      src = fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "GNOME";
        repo = "vte";
        rev = "3c8f66be867aca6656e4109ce880b6ea7431b895";
        hash = "sha256-vz9ircmPy2Q4fxNnjurkgJtuTSS49rBq/m61p1B43eU=";
      };
    } // lib.optionalAttrs sixelSupport {
      buildInputs = old.buildInputs ++ [ libsixel ];
      mesonFlags = old.mesonFlags ++ [ "-Dsixel=true" ];
    }))
    json-glib
    marble
    libadwaita
    pcre2
    libxml2
    librsvg
    libgee
  ];

  mesonFlags = [ "-Dblackbox_is_flatpak=false" ];

  meta = with lib; {
    description = "Beautiful GTK 4 terminal";
    mainProgram = "blackbox";
    homepage = "https://gitlab.gnome.org/raggesilver/blackbox";
    changelog = "https://gitlab.gnome.org/raggesilver/blackbox/-/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu linsui ];
    platforms = platforms.linux;
  };
}
