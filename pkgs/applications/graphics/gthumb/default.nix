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
  version = "3.8.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1a0gss9cjcwayrcpkam5kc1giwbfy38jgqxvh33in9gfq9dgrygg";
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
    gst_all_1.gstreamer
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
