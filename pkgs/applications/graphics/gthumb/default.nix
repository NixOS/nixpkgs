{ stdenv
, fetchurl
, fetchpatch
, gnome3
, pkgconfig
, meson
, ninja
, exiv2
, libjpeg
, libtiff
, gst_all_1
, libraw
, libsoup
, libsecret
, glib
, gtk3
, gsettings-desktop-schemas
, libchamplain
, librsvg
, libwebp
, json-glib
, webkitgtk
, lcms2
, bison
, flex
, clutter-gtk
, wrapGAppsHook
, shared-mime-info
, python3
, desktop-file-utils
, itstool
}:

stdenv.mkDerivation rec {
  pname = "gthumb";
  version = "3.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0j7cxp4hhkvkckyvll6pmqkv5rwrknlzq9j1my0grb01b8wzhw9y";
  };

  nativeBuildInputs = [
    bison
    desktop-file-utils
    flex
    itstool
    meson
    ninja
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    exiv2
    glib
    gnome3.adwaita-icon-theme
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gtk3
    json-glib
    lcms2
    libchamplain
    libjpeg
    libraw
    librsvg
    libsecret
    libsoup
    libtiff
    libwebp
    webkitgtk
  ];

  mesonFlags = [
    "-Dlibchamplain=true"
  ];

  postPatch = ''
    chmod +x gthumb/make-gthumb-h.py

    patchShebangs data/gschemas/make-enums.py \
      gthumb/make-gthumb-h.py \
      po/make-potfiles-in.py \
      postinstall.py \
      gthumb/make-authors-tab.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Gthumb";
    description = "Image browser and viewer for GNOME";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.mimame ];
  };
}
