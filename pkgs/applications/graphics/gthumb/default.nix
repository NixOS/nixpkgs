{ stdenv
, lib
, fetchurl
, fetchpatch
, gnome
, pkg-config
, meson
, ninja
, exiv2
, libheif
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
  version = "3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-l/iv5SJTUhZUHrvx47VG0Spr6zio8OuF8m5naTSq1CU=";
  };

  patches = [
    # Fix build with libraw 0.21, can be removed on next update
    # https://hydra.nixos.org/build/209327709/nixlog/1
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gthumb/-/commit/da0d3f22a5c3a141211d943e7d963d14090011ec.patch";
      sha256 = "sha256-/l9US19rKxIUJjZ+oynGLr/9PKJPg9VUuA/VSuIT5AQ=";
    })

    # Fix build with exiv2 0.28, can be removed on next update
    # https://gitlab.gnome.org/GNOME/gthumb/-/issues/282
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gthumb/-/commit/3376550ae109286de09ce5f89e05060eb80230a7.patch";
      sha256 = "sha256-zHX+kV7RaHXFqbR15RTaRcZJPU/P3uUj03tFUv0DR5o=";
    })
  ];

  nativeBuildInputs = [
    bison
    desktop-file-utils
    flex
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    exiv2
    glib
    gnome.adwaita-icon-theme
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
    libheif
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
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Gthumb";
    description = "Image browser and viewer for GNOME";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.mimame ];
  };
}
