{ stdenv
, fetchurl
, fetchpatch
, atk
, cairo
, desktop-file-utils
, evolution-data-server
, gcr
, gettext
, glib
, gnome3
, gpgme
, gtk3
, gtksourceview3
, gtkspell3
, libcryptui
, libxml2
, meson
, ninja
, pkgconfig
, sqlite
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "almanah";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "09rxx4s4c34d1axza6ayss33v78p44r9bpx058shllh1sf5avpcb";
  };

  patches = [
    # Fix gpgme detection
    # https://gitlab.gnome.org/GNOME/almanah/merge_requests/7
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/almanah/commit/4b979c4145ef2fbceebb3849a70df1d0ceb1bb93.patch";
      sha256 = "0wwkgqr5vi597j734xq0fwgk1zpcabp8wi8b1lnb1ksnqfi3wwxb";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    cairo
    evolution-data-server
    gcr
    glib
    gnome3.evolution
    gpgme
    gtk3
    gtksourceview3
    gtkspell3
    libcryptui
    sqlite
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none"; # it is quite odd
    };
  };

  meta = with stdenv.lib; {
    description = "Small GTK application to allow to keep a diary of your life";
    homepage = "https://wiki.gnome.org/Apps/Almanah_Diary";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
