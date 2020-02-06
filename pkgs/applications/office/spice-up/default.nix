{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, gdk-pixbuf
, gtk3
, vala
, gettext
, ninja
, pantheon
, pkgconfig
, json-glib
, libgudev
, libevdev
, libgee
, libsoup
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "spice-up";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "Philip-Scott";
    repo = "Spice-up";
    rev = version;
    sha256 = "1pix911l4ddn50026a5sbpqfzba6fmw40m1yzbknmkgd2ny28f0m";
  };

  USER = "pbuilder";

  nativeBuildInputs = [
    cmake
    gettext
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    pantheon.elementary-icon-theme
    pantheon.granite
    gdk-pixbuf
    gtk3
    json-glib
    libevdev
    libgee
    libgudev
    libsoup
  ];

  patches = [
    # Fix build with Vala 0.46
    # https://github.com/Philip-Scott/Spice-up/pull/288
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/Philip-Scott/Spice-up/pull/288.patch";
      sha256 = "0kyfd8v2sk4cvcq1j8ysp64snfjhnpr3iz7l04lx7if7h372xj39";
    })
  ];

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Create simple and beautiful presentations";
    homepage = https://github.com/Philip-Scott/Spice-up;
    maintainers = with maintainers; [ samdroid-apps kjuvi ] ++ pantheon.maintainers;
    platforms = platforms.linux;
    # The COPYING file has GPLv3; some files have GPLv2+ and some have GPLv3+
    license = licenses.gpl3Plus;
  };
}
