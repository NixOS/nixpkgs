{ lib
, stdenv
, fetchurl
, fetchpatch
, gettext
, gnome
, libgtop
, gtk3
, libhandy
, pcre2
, vte
, appstream-glib
, desktop-file-utils
, git
, meson
, ninja
, pkg-config
, python3
, sassc
, wrapGAppsHook
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "gnome-console";
  version = "42.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-console/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "fSbmwYdExXWnhykyY/YM7/YwEHCY6eWKd2WwCsdDcEk=";
  };

  patches = [
    # Fix Nautilus extension in 43.
    # https://gitlab.gnome.org/GNOME/console/-/merge_requests/104
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/console/-/commit/e0131faeabdce95bfe1ea260b1ed439120abf1db.patch";
      sha256 = "56lw/lTshVVda31ohcS8j38JL4UwyvtmSLEYkUMYylY=";
    })
  ];

  buildInputs = [
    gettext
    libgtop
    gnome.nautilus
    gtk3
    libhandy
    pcre2
    vte
  ];

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    git
    meson
    ninja
    pkg-config
    python3
    sassc
    wrapGAppsHook
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  passthru.tests.test = nixosTests.terminal-emulators.kgx;

  meta = with lib; {
    description = "Simple user-friendly terminal emulator for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/GNOME/console";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ zhaofengli ]);
    platforms = platforms.linux;
  };
}
