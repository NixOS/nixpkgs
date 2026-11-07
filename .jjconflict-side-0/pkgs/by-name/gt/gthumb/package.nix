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
  libadwaita,
  gst_all_1,
  libraw,
  glib,
  gtk4,
  libportal-gtk4,
  gsettings-desktop-schemas,
  libjxl,
  librsvg,
  libwebp,
  lcms2,
  colord,
  wrapGAppsHook4,
  shared-mime-info,
  python3,
  desktop-file-utils,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gthumb";
  version = "4.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gthumb/${lib.versions.majorMinor finalAttrs.version}/gthumb-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-okqqcrVjf0kJfe3JwUGjNhXadw0CkxXzKF6/IVbPe2E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
    vala
  ];

  buildInputs = [
    colord
    exiv2
    glib
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gtk4
    lcms2
    libadwaita
    libheif
    libjpeg
    libjxl
    libportal-gtk4
    libraw
    librsvg
    libtiff
    libwebp
  ];

  postPatch = ''
    patchShebangs po/make-potfiles-in.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gthumb";
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
