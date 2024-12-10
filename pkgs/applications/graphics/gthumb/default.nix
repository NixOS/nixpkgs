{
  stdenv,
  lib,
  fetchurl,
  gnome,
  pkg-config,
  meson,
  ninja,
  exiv2,
  libheif,
  libjpeg,
  libtiff,
  gst_all_1,
  libraw,
  libsoup,
  libsecret,
  glib,
  gtk3,
  gsettings-desktop-schemas,
  libchamplain,
  librsvg,
  libwebp,
  libX11,
  json-glib,
  webkitgtk,
  lcms2,
  bison,
  flex,
  clutter-gtk,
  wrapGAppsHook3,
  shared-mime-info,
  python3,
  desktop-file-utils,
  itstool,
}:

stdenv.mkDerivation rec {
  pname = "gthumb";
  version = "3.12.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-YIdwxsjnMHOh1AS2W9G3YeGsXcJecBMP8HJIj6kvXDM=";
  };

  nativeBuildInputs = [
    bison
    desktop-file-utils
    flex
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
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
    libX11
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
    homepage = "https://gitlab.gnome.org/GNOME/gthumb";
    description = "Image browser and viewer for GNOME";
    mainProgram = "gthumb";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.mimame ];
  };
}
