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
  glib,
  gtk3,
  gsettings-desktop-schemas,
  libjxl,
  librsvg,
  libwebp,
  libX11,
  lcms2,
  bison,
  brasero,
  flex,
  clutter-gtk,
  colord,
  wrapGAppsHook3,
  shared-mime-info,
  python3,
  desktop-file-utils,
  itstool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gthumb";
  version = "3.12.9";

  src = fetchurl {
    url = "mirror://gnome/sources/gthumb/${lib.versions.majorMinor finalAttrs.version}/gthumb-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-13+ItWneSSV4BzDnhnspB3GNpmBowkLd6bvaEH4YP/o=";
  };

  strictDeps = true;

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
    brasero
    clutter-gtk
    colord
    exiv2
    glib
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gtk3
    lcms2
    libheif
    libjpeg
    libjxl
    libraw
    librsvg
    libtiff
    libwebp
    libX11
  ];

  postPatch = ''
    chmod +x gthumb/make-gthumb-h.py

    patchShebangs data/gschemas/make-enums.py \
      gthumb/make-gthumb-h.py \
      po/make-potfiles-in.py \
      gthumb/make-authors-tab.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gthumb";
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gthumb";
    description = "Image browser and viewer for GNOME";
    mainProgram = "gthumb";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      bobby285271
      mimame
    ];
  };
})
